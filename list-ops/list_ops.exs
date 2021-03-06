defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(l), do: count(l, 0)

  defp count([], counter), do: counter

  defp count([_ | tail], counter), do: count(tail, counter + 1)

  def reverse([]), do: []

  @spec reverse(list) :: list
  def reverse(l), do: reverse(l, [])

  defp reverse([], acc), do: acc

  defp reverse([head | tail], acc), do: reverse(tail, [head | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: reverse(map(l, f, []))

  defp map([], _, acc), do: acc

  defp map([head | tail], f, acc), do: map(tail, f, [f.(head) | acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: reverse(filter(l, f, []))

  defp filter([], _, acc), do: acc

  defp filter([head | tail], f, acc) do
    if f.(head) do
      filter(tail, f, [head | acc])
    else
      filter(tail, f, acc)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _), do: acc

  def reduce([head | tail], acc, f), do: reduce(tail, f.(head, acc), f)

  @spec append(list, list) :: list

  def append(a, b) do
    acc =
      b
      |> reverse()
      |> append_to_acc([])

    a
    |> reverse()
    |> append_to_acc(acc)
  end

  def append_to_acc([], acc), do: acc
  def append_to_acc([head | tail], acc), do: append_to_acc(tail, [head | acc])

  @spec concat([[any]]) :: [any]
  def concat([]), do: []

  def concat(ll) do
    ll
    |> reverse()
    |> concat([])
  end

  defp concat([], acc), do: acc

  defp concat([head | tail], acc), do: concat(tail, append_to_acc(reverse(head), acc))
end
