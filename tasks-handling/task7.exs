# This demonstrates that, when using async_nolink, the task only crashes
# the caller when we call await.  Note that "I'm still alive" is not
# printed
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
Task.await(a)
Task.await(b)

IO.puts "I'm still alive"

# % elixir task7.exs
# Starting async_nolink GOOD
# Starting async_nolink BAD
# Awaiting both
# -> Start GOOD
# -> Start BAD
#
# 09:55:05.130 [error] Task #PID<0.55.0> started from #PID<0.47.0> terminating
# ** (RuntimeError) I'm BAD!
#     task7.exs:13: Tasker.bad/1
#     (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#     (elixir) lib/task/supervised.ex:40: Task.Supervised.reply/5
#     (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
# Function: &Tasker.bad/1
#     Args: ["-> Start BAD"]
# ** (exit) exited in: Task.await(%Task{owner: #PID<0.47.0>, pid: #PID<0.55.0>, ref: #Reference<0.0.1.14>}, 5000)
#     ** (EXIT) an exception was raised:
#         ** (RuntimeError) I'm BAD!
#             task7.exs:13: Tasker.bad/1
#             (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#             (elixir) lib/task/supervised.ex:40: Task.Supervised.reply/5
#             (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
#     (elixir) lib/task.ex:332: Task.await/2
#     task7.exs:28: (file)
#     (elixir) lib/code.ex:363: Code.require_file/2
#
#
# 09:55:05.157 [error] GenServer #PID<0.53.0> terminating
# ** (stop) exited in: Task.await(%Task{owner: #PID<0.47.0>, pid: #PID<0.55.0>, ref: #Reference<0.0.1.14>}, 5000)
#     ** (EXIT) an exception was raised:
#         ** (RuntimeError) I'm BAD!
#             task7.exs:13: Tasker.bad/1
#             (elixir) lib/task/supervised.ex:89: Task.Supervised.do_apply/2
#             (elixir) lib/task/supervised.ex:40: Task.Supervised.reply/5
#             (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
# Last message: {:EXIT, #PID<0.47.0>, {{%RuntimeError{message: "I'm BAD!"}, [{Tasker, :bad, 1, [file: 'task7.exs', line: 13]}, {Task.Supervised, :do_apply, 2, [file: 'lib/task/supervised.ex', line: 89]}, {Task.Supervised, :reply, 5, [file: 'lib/task/supervised.ex', line: 40]}, {:proc_lib, :init_p_do_apply, 3, [file: 'proc_lib.erl', line: 240]}]}, {Task, :await, [%Task{owner: #PID<0.47.0>, pid: #PID<0.55.0>, ref: #Reference<0.0.1.14>}, 5000]}}}
# State: {:state, {#PID<0.53.0>, Supervisor.Default}, :simple_one_for_one, [{:child, :undefined, Task.Supervised, {Task.Supervised, :start_link, []}, :temporary, 5000, :worker, [Task.Supervised]}], {:set, 0, 16, 16, 8, 80, 48, {[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []}, {{[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []}}}, 3, 5, [], Supervisor.Default, {:ok, {{:simple_one_for_one, 3, 5}, [{Task.Supervised, {Task.Supervised, :start_link, []}, :temporary, 5000, :worker, [Task.Supervised]}]}}}
