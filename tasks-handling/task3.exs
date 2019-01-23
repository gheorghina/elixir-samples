# This demonstrates that, when using start_link, the caller will not wait around
# on the task to finish - the caller will finish regardless of what happens in the
# task.
defmodule Tasker do
  def good(message) do
    :timer.sleep 500
    IO.puts message
  end

  def bad(message) do
    :timer.sleep 500
    IO.puts message
    raise "I'm BAD!"
    IO.puts "After CRASH"
  end
end

IO.puts "Starting start_link GOOD"
{:ok, pid1} = Task.start_link(Tasker, :good, ["-> Start Link GOOD"])

IO.puts "Starting start_link BAD"
{:ok, pid2} = Task.start_link(Tasker, :bad, ["-> Start Link BAD"])

IO.puts "PIDS:"
IO.inspect pid1
IO.inspect pid2
# There is no way to wait!

# % elixir task3.exs
# Starting start_link GOOD
# Starting start_link BAD
# PIDS:
# #PID<0.53.0>
# #PID<0.54.0>
