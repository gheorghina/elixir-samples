defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """
  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    tuple_len = numbers |> :erlang.tuple_size()

    cond do
      tuple_len == 0 ->
        :not_found

      tuple_len != 0 and Kernel.elem(numbers, tuple_len - 1) < key ->
          :not_found

      true ->
        numbers |> search(key, 0, tuple_len - 1)
    end
  end

  defp search(numbers, key, range_min, range_max) do
    mid_elem_pos = ((range_min + range_max) / 2) |> round()
    mid_elem = numbers |> Kernel.elem(mid_elem_pos)

    cond do
      range_min > range_max ->
        :not_found

      mid_elem == key ->
        {:ok, mid_elem_pos}

      mid_elem > key ->
        numbers |> search(key, range_min, mid_elem_pos - 1)

      mid_elem < key ->
        numbers |> search(key, mid_elem_pos + 1, range_max)
    end
  end
end
