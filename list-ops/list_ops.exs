defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(l), do:  count(l, 0)

  defp count([], counter), do: counter

  defp count([_|tail], counter) do
    count(tail, counter + 1)
  end

  def reverse([]), do: []

  @spec reverse(list) :: list
  def reverse(l), do: reverse(l, [])

  defp reverse([], acc), do: acc

  defp reverse([head|tail], acc) do
    reverse(tail, [head | acc])
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: reverse(map(l, f, []))

  defp map([], f, acc), do: acc

  defp map([head|tail], f, acc) do
    map(tail, f, [f.(head) | acc])
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(l, acc, f) do
  end

  @spec append(list, list) :: list
  def append(a, b) do
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
  end
end
