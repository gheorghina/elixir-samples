# This demonstrates that, when using async/await, a crash in the task will crash the caller
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
Task.await(a)
Task.await(b)

# % elixir task1.exs
# Starting Async GOOD
# Starting Async BAD
# -> Async GOOD
# -> Async BAD
# ** (EXIT from #PID<0.47.0>) an exception was raised:
#     ** (RuntimeError) I'm BAD!
#         task1.exs:8: Tasker.bad/1
#         (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#         (elixir) lib/task/supervised.ex:40: Task.Supervised.reply/5
#         (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
#
# 09:06:08.269 [error] Task #PID<0.54.0> started from #PID<0.47.0> terminating
# ** (RuntimeError) I'm BAD!
#     task1.exs:8: Tasker.bad/1
#     (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#     (elixir) lib/task/supervised.ex:40: Task.Supervised.reply/5
#     (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
# Function: &Tasker.bad/1
#     Args: ["-> Async BAD"]
