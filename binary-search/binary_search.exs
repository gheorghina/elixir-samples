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
  @not_found :not_found

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    search_in_tuple(numbers |> Tuple.to_list(), key)
  end

  defp search_in_tuple(numbers, key) do
    list_len = numbers |> length()
    last_elem = numbers |> List.last()

    cond do
      (last_elem == nil) or (last_elem < key) or ((list_len == 1) and (last_elem != key)) -> @not_found
      last_elem == key -> {:ok, list_len - 1}
      true ->
        split_len = list_len/2 |> round
        [list_1, list_2] = numbers |> Enum.chunk(split_len, split_len,[])

        cond do
          list_1 |> is_in_list(key) -> list_1 |> search_in_tuple(key)
          list_2 |> is_in_list(key) -> list_2 |> search_in_tuple(key)
        end
    end
  end

  defp is_in_list(list, key) do
    last_elem = list |> List.last()
    if last_elem >= key do
      true
    else
      false
    end
  end
end
