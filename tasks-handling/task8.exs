# This demonstrates that, when using async_nolink, the task does not crash
# if we use `yield` to capture results
# Note that "I'm still alive" IS printed, and we get results from the tasks
defmodule Tasker do
  def good(message) do
    :timer.sleep(1000)
    IO.puts message
  end

  def bad(message) do
    :timer.sleep(1000)
    IO.puts message
    raise "I'm BAD!"
  end
end

{:ok, pid} = Task.Supervisor.start_link()

IO.puts "Starting async_nolink GOOD"
a = Task.Supervisor.async_nolink(pid, Tasker, :good, ["-> Start GOOD"])

IO.puts "Starting async_nolink BAD"
b = Task.Supervisor.async_nolink(pid, Tasker, :bad, ["-> Start BAD"])


IO.puts "Awaiting both"
res_a = Task.yield(a)
res_b = Task.yield(b)

IO.puts "I'm still alive"
IO.puts "Result A: #{inspect(res_a)}"
IO.puts "Result B: #{inspect(res_b)}"

# % elixir task8.exs
# Starting async_nolink GOOD
# Starting async_nolink BAD
# Awaiting both
# -> Start GOOD
# -> Start BAD
# I'm still alive
# Result A: {:ok, :ok}
#
# 09:57:48.659 [error] Task #PID<0.55.0> started from #PID<0.47.0> terminating
# ** (RuntimeError) I'm BAD!
#     task8.exs:13: Tasker.bad/1
#     (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#     (elixir) lib/task/supervised.ex:40: Task.Supervised.reply/5
#     (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
# Function: &Tasker.bad/1
#     Args: ["-> Start BAD"]
# Result B: {:exit, {%RuntimeError{message: "I'm BAD!"}, [{Tasker, :bad, 1, [file: 'task8.exs', line: 13]}, {Task.Supervised, :do_apply, 2, [file: 'lib/task/supervised.ex', line: 89]}, {Task.Supervised, :reply, 5, [file: 'lib/task/supervised.ex', line: 40]}, {:proc_lib, :init_p_do_apply, 3, [file: 'proc_lib.erl', line: 240]}]}}
