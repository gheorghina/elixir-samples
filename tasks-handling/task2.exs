# This demonstrates that, when using async/yield, a crash in the task will crash the caller.
# i.e. `async` always links the processes!  Note that "I'm still alive" is not printed
defmodule Tasker do
  def good(message) do
    IO.puts message
  end

  def bad(message) do
    IO.puts message
    raise "I'm BAD!"
  end
end

IO.puts "Starting Async GOOD"
a = Task.async(Tasker, :good, ["-> Async GOOD"])

IO.puts "Starting Async BAD"
b = Task.async(Tasker, :bad, ["-> Async BAD"])

:timer.sleep 500
IO.puts "Awaiting both"
Task.yield(a)
Task.yield(b)

IO.puts "I'm still alive"

# % elixir task2.exs
# Starting Async GOOD
# Starting Async BAD
# -> Async GOOD
# -> Async BAD
# ** (EXIT from #PID<0.47.0>) an exception was raised:
#     ** (RuntimeError) I'm BAD!
#         task2.exs:9: Tasker.bad/1
#         (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#         (elixir) lib/task/supervised.ex:40: Task.Supervised.reply/5
#         (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
#
# 09:08:23.912 [error] Task #PID<0.54.0> started from #PID<0.47.0> terminating
# ** (RuntimeError) I'm BAD!
#     task2.exs:9: Tasker.bad/1
#     (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#     (elixir) lib/task/supervised.ex:40: Task.Supervised.reply/5
#     (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
# Function: &Tasker.bad/1
#     Args: ["-> Async BAD"]
#
