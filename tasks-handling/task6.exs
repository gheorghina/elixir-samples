# This demonstrates that, when using start, the task does not crash the caller,
# but the tasks do not live past the life of the caller.  I've switched from
# `IO.puts` in the tasks to `File.write` to show that the side-effect never
# happens.
defmodule Tasker do
  def good(message) do
    :timer.sleep(1000)
    File.write("./task_good.txt", "#{message} - #{inspect(make_ref)}")
  end

  def bad(message) do
    :timer.sleep(1000)
    File.write("./task_bad.txt", "#{message} - #{inspect(make_ref)}")
    raise "I'm BAD!"
  end
end

IO.puts "Starting start GOOD"
{:ok, pid1} = Task.start(Tasker, :good, ["-> Start GOOD"])

IO.puts "Starting start BAD"
{:ok, pid2} = Task.start(Tasker, :bad, ["-> Start BAD"])

IO.puts "PIDS:"
IO.inspect pid1
IO.inspect pid2

# % elixir task6.exs
# Starting start GOOD
# Starting start BAD
# PIDS:
# #PID<0.53.0>
# #PID<0.54.0>
# % ls task_*.txt
# ls: task_*.txt: No such file or directory
