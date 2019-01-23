# This demonstrates that, when using start_link, the task can crash the caller
# if the caller is still running.
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

IO.puts "Starting start_link GOOD"
{:ok, pid1} = Task.start_link(Tasker, :good, ["-> Start Link GOOD"])

IO.puts "Starting start_link BAD"
{:ok, pid2} = Task.start_link(Tasker, :bad, ["-> Start Link BAD"])

:timer.sleep(1000)
IO.puts "PIDS:"
IO.inspect pid1
IO.inspect pid2

# % elixir task4.exs
# Starting start_link GOOD
# Starting start_link BAD
# -> Start Link GOOD
# -> Start Link BAD
# ** (EXIT from #PID<0.47.0>) an exception was raised:
#     ** (RuntimeError) I'm BAD!
#         task4.exs:10: Tasker.bad/1
#         (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#         (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
#
# 09:19:30.200 [error] Task #PID<0.54.0> started from #PID<0.47.0> terminating
# ** (RuntimeError) I'm BAD!
#     task4.exs:10: Tasker.bad/1
#     (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#     (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
# Function: &Tasker.bad/1
#     Args: ["-> Start Link BAD"]
