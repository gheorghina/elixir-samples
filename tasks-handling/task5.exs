# This demonstrates that, when using start, the task does not crash the caller
# (but the exception status is printed to the screen)
defmodule Tasker do
  def good(message) do
    IO.puts message
  end

  def bad(message) do
    IO.puts message
    raise "I'm BAD!"
    IO.puts "After CRASH"
  end
end

IO.puts "Starting start GOOD"
{:ok, pid1} = Task.start(Tasker, :good, ["-> Start GOOD"])

IO.puts "Starting start BAD"
{:ok, pid2} = Task.start(Tasker, :bad, ["-> Start BAD"])

:timer.sleep(1000)
IO.puts "PIDS:"
IO.inspect pid1
IO.inspect pid2

# % elixir task5.exs
# Starting start GOOD
# Starting start BAD
# -> Start GOOD
# -> Start BAD
#
# 09:21:51.944 [error] Task #PID<0.54.0> started from #PID<0.47.0> terminating
# ** (RuntimeError) I'm BAD!
#     task5.exs:9: Tasker.bad/1
#     (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#     (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
# Function: &Tasker.bad/1
#     Args: ["-> Start BAD"]
# PIDS:
# #PID<0.53.0>
# #PID<0.54.0>
