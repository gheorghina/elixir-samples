var AWS = require('aws-sdk');
var cloudwatch = new AWS.CloudWatch({ region: 'us-east-1'});

exports.handler = function (event, context) {

    var ElasticSearchHost = 'elasticsearch.example:9200';
    var Environment = 'int';
    var EndTime = new Date;
    var StartTime = new Date(EndTime - 15*60*1000);
    var Metrics = {
        AutoScalingGroup: [{
            'Namespace': 'System/Detail/Linux',
            'MetricNames': [
                "LoadAverage1Min","LoadAverage5Min","LoadAverage15Min",
                "ContextSwitch","Interrupt",
                "CpuUser","CpuIdle","CpuWait","CpuSteal",
                "MemoryUtilization","MemoryUsed","MemoryAvailable",
                "SwapUtilization","SwapUsed","SwapAvailable",
                "DiskSpaceUtilization","DiskSpaceUsed","DiskSpaceAvailable"
            ]
        },{
            'Namespace': 'AWS/EC2',
            'MetricNames': ['CPUUtilization','NetworkIn']
        }],
        'LoadBalancer': [{
            'Namespace': 'AWS/ELB',
            'MetricNames': ['HealthyHostCount','UnHealthyHostCount','RequestCount','HTTPCode_Backend_2XX','HTTPCode_Backend_3XX','HTTPCode_Backend_4XX','HTTPCode_Backend_5XX']
        }],
        'ElastiCache': [{
            'Namespace': 'AWS/ElastiCache',
            'MetricNames': ['CacheMisses','CacheHits','CPUUtilization','CurrItems','CurrConnections']
        }],
        'Database': [{
            'Namespace': 'AWS/RDS',
            'MetricNames': [
                'DatabaseConnections','CPUUtilization','SwapUsage',
                'WriteIOPS','ReadIOPS',
                'WriteLatency','ReadLatency',
                'WriteThroughput','ReadThroughput'
            ]
        }]
    };

    console.log('Start: ' + StartTime);
    console.log('End: ' + EndTime);

    var bulkData = {body:[]};
    var callbackLevel = 0;

    var getMetricStatistics = function(type, dimensions) {
        Metrics[type].forEach(function (metric) {
            var Namespace = metric.Namespace;
            metric.MetricNames.forEach(function (MetricName) {
                callbackLevel++;
                var params = {
                    Period: 60,
                    StartTime: StartTime,
                    EndTime: EndTime,
                    MetricName: MetricName,
                    Namespace: Namespace,
                    Statistics: ['SampleCount', 'Average', 'Sum', 'Minimum', 'Maximum'],
                    Dimensions: dimensions
                };
                console.log('Fetching ' + Namespace + ':' + MetricName + ' for ' + dimensions[0].Value);
                cloudwatch.getMetricStatistics(params, function (err, data) {
                    if (err) {
                        console.log(err, err.stack);
                    } else {
                        data.Datapoints.forEach(function (datapoint) {

                            datapoint.Namespace = Namespace;
                            datapoint.MetricName = MetricName;
                            datapoint.Dimension = dimensions[0];
                            datapoint.Environment = Environment;

                            var type = Namespace + ':' + MetricName;
                            if (Namespace == 'AWS/ELB') {
                                type += ':' + dimensions[1].Value;
                                datapoint.AvailabilityZone = dimensions[1].Value;
                            }
                            if (Namespace == 'AWS/ElastiCache') {
                                type += ':' + dimensions[0].Value;
                            }

                            console.log('Datapoint: ' + type);

                            console.log(datapoint);

                            // push instruction
                            bulkData.body.push({
                                index: {
                                    _index: 'cloudwatch',
                                    _type: type,
                                    _id: Math.floor(datapoint.Timestamp.getTime() / 1000)
                                }
                            });

                            // push data
                            bulkData.body.push(datapoint);
                        });

                        callbackLevel--;
                        if (callbackLevel == 0) {
                            sendToElasticSearch(bulkData);
                        }
                    }
                });
            })
        });
    };

    var sendToElasticSearch = function(bulkData) {
        if (bulkData.body.length > 0) {
            console.log('Sending ' + (bulkData.body.length/2) + ' metrics to ElasticSearch:');
            //console.log(bulkData.body);
            var elasticsearch = require('elasticsearch');
            var elasticSearchClient = new elasticsearch.Client({ host: ElasticSearchHost });
            elasticSearchClient.bulk(bulkData, function(err, data) {
                if (err) {
                    errorExit(err, context);
                } else {
                    // console.log(data);
                    context.succeed();
                }
            });
        } else {
            context.done();
        }
    };

    var findElastiCache = function(callback) {
        var elasticache = new AWS.ElastiCache({apiVersion: '2015-02-02', region: 'us-east-1'});
        elasticache.describeCacheClusters({}, function(err, data) {
            if (err) {
                callback(err, data);
            } else {
                var found = 0;
                data.CacheClusters.forEach(function(item) {
                    if (item.CacheClusterId.indexOf('mg-'+Environment) == 0) {
                        found++;
                        callback(null, item.CacheClusterId);
                    }
                });
                if (found != 2) {
                    callback('Could not find both ElastiCache clusters', null);
                }
            }
        });
    };

    var findDatabase = function(callback) {
        var rds = new AWS.RDS({apiVersion: '2014-10-31', region: 'us-east-1'});
        rds.describeDBInstances({}, function(err, data) {
            if (err) {
                callback(err, data);
            } else {
                var found = 0;
                data.DBInstances.forEach(function(item) {
                    if (item.DBName == 'mg_'+Environment) {
                        found++;
                        callback(null, item.DBInstanceIdentifier);
                    }
                });
                if (!found) {
                    callback('Database not found', null);
                }
            }
        });
    };

    var findLoadBalancerName = function(callback) {
        var elb = new AWS.ELB({ region: 'us-east-1'});
        elb.describeLoadBalancers({}, function(err, data) {
            if (err) {
                callback(err, data);
            } else {
                var found = 0;
                var names = [];
                // find loadbalancer by tag
                data.LoadBalancerDescriptions.forEach(function (item) {
                    names.push(item.LoadBalancerName);
                });
                elb.describeTags({ LoadBalancerNames: names }, function(err, data) {
                    if (err) {
                        callback(err, null);
                    } else {
                        data.TagDescriptions.forEach(function(item) {
                            var assocTags = convertToAssocTags(item.Tags);
                            if (assocTags.Environment == Environment
                                && assocTags.Type == 'Frontend'
                            ) {
                                found++;
                                callback(null, item.LoadBalancerName);
                            }
                        });
                        if (!found) {
                            callback('No load balancer found', null);
                        }
                    }
                });
            }
        });
    };

    var findAutoScalingGroup = function(callback) {
        var autoscaling = new AWS.AutoScaling({ region: 'us-east-1'});
        autoscaling.describeAutoScalingGroups({}, function(err, data) {
            if (err) {
                callback(err, data);
            } else {
                var found = 0;
                // find autoscaling group by tag
                data.AutoScalingGroups.forEach(function (item) {
                    var assocTags = convertToAssocTags(item.Tags);
                    if (assocTags.Environment == Environment
                        && assocTags.Type == 'Magento'
                    ) {
                        found++;
                        callback(null, item.AutoScalingGroupName);
                    }
                });
                if (!found) {
                    callback('No autoscaling group found', null);
                }
            }
        })
    };

    var convertToAssocTags = function (tags) {
        var assocTags = {};
        tags.forEach(function(tag) {
            assocTags[tag.Key] = tag.Value;
        });
        return assocTags;
    };

    var errorExit = function (message, context) {
        var res = {Error: message};
        console.log(res.Error);
        context.fail(res);
    };

    callbackLevel++;

    findElastiCache(function(err, CacheClusterId) {
        if (err) {
            console.log(err, err.stack);
        } else {
            getMetricStatistics('ElastiCache', [{Name: 'CacheClusterId', Value: CacheClusterId}]);
        }
    });

    findDatabase(function(err, DBInstanceIdentifier) {
        if (err) {
            console.log(err, err.stack);
        } else {
            getMetricStatistics('Database', [{Name: 'DBInstanceIdentifier', Value: DBInstanceIdentifier}]);
        }
    });

    findLoadBalancerName(function(err, LoadBalancerName) {
        if (err) {
            console.log(err, err.stack);
        } else {
            ['a', 'b', 'c', 'd', 'e'].forEach(function(value) {
                getMetricStatistics('LoadBalancer', [
                    {Name: 'LoadBalancerName', Value: LoadBalancerName},
                    {Name: 'AvailabilityZone', Value: 'us-east-1'+value}
                ]);
            });

        }
    });

    findAutoScalingGroup(function(err, AutoScalingGroupName) {
        if (err) {
            console.log(err, err.stack);
        } else {
            getMetricStatistics('AutoScalingGroup', [{Name: 'AutoScalingGroupName', Value: AutoScalingGroupName}]);
        }
    });

    callbackLevel--;
};