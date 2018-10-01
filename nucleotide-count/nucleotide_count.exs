defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """


  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) do
    if is_empty(strand) do
      0
    else
      count(String.codepoints(strand), nucleotide, 0)
    end

  end

  defp count([head | tail], nucleotide, counter) do
    cond do

      head == nucleotide -> count(tail, nucleotide, 1 + counter)

      true -> count(tail, nucleotide, counter)

    end
  end

  defp count([], _, counter) do
    counter
  end

  defp is_empty(x) do
    case x do
      x when is_nil(x) -> true
      x when is_list(x) -> length(x) == 0
      x when is_binary(x) -> String.length(x) == 0
      _ -> false
    end
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  # @spec histogram([char]) :: map
  # def histogram(strand) do
  # end
end
