defmodule TasksMonitoring do

  def run(delay) do
    t = async(my_fun(delay))

    try do
      result = await(t, 5000)
      IO.puts("Got: #{inspect result}")

    catch
      :exit, reason ->
        IO.puts("EXIT: #{inspect reason}")
    end

  end

  def my_fun(delay) when is_integer(delay) do

    fn ->
      {timeout, crash} =
        cond do
          delay >= 0 ->
            {delay, false}
          true ->
            {-delay, true}
        end

      Process.sleep(timeout)

      cond do
        crash ->
          exit(:crash) # crash the task
        true ->
          timeout      # return result
      end
    end

  end

  #
  # ---
  #

  def async(fun) do
    owner = self()
    {:ok, pid} = Task.start(reply(fun, 5000))
    ref = Process.monitor(pid)
    send(pid, {owner, ref})
    %Task{pid: pid, ref: ref, owner: owner}
  end

  def await(%Task{ref: ref, owner: owner} = task, timeout) when owner == self() do
    receive do
      {^ref, reply} ->
        Process.demonitor(ref, [:flush])
        reply

      {:DOWN, ^ref, _, _proc, reason} ->
        exit({reason, {__MODULE__, :await, [task, timeout]}})

    after
      timeout ->
        Process.demonitor(ref, [:flush])
        exit({:timeout, {__MODULE__, :await, [task, timeout]}})
    end
  end

  defp reply(fun, timeout) do
    fn ->
      receive do
        {caller, ref} ->
          send(caller, {ref, fun.()})
      after
        timeout ->
          exit(:timeout)
      end
    end
  end

end

TasksMonitoring.run(500)
TasksMonitoring.run(-500)
IO.puts("Demo complete")
