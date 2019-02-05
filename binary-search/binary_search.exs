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
  def search(numbers, key) when is_tuple(numbers) do
    search(numbers |> Tuple.to_list(), key)
  end

  def search(numbers, key, start_index \\ 0) when is_list(numbers) do
    list_len = numbers |> length()
    last_elem = numbers |> List.last()

    cond do
      last_elem == nil ->
        :not_found

      last_elem < key ->
        :not_found

      list_len == 1 and last_elem != key ->
        :not_found

      last_elem == key ->
        {:ok, start_index + (list_len - 1)}

      true ->
        split_len = (list_len / 2) |> round
        [left_list, right_list] = numbers |> Enum.chunk(split_len, split_len, [])

        if List.last(left_list) >= key do
          left_list |> search(key, start_index)
        else
          right_list |> search(key, start_index + split_len)
        end
    end
  end
end
