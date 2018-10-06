defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @punctuation_regex ~r/[,.:!@$%^&]/
  @split_clause_regex ~r/[_\ ]/ 

  @spec count(String.t()) :: map
  def count(sentence) do

    w_list =  sentence
              |> String.downcase()
              |> String.replace(@punctuation_regex, "")
              |> String.replace("  ", " ")
              |> String.split( @split_clause_regex)

    countw(w_list)

  end

  defp countw(words, w_map \\ %{})
  defp countw([], w_map) do
    w_map
  end
  defp countw([head | tail], w_map) do
    count = w_map
            |> Map.get(head, 0)

    w_map = w_map
            |> Map.merge(%{ head => 1 + count})

    countw(tail, w_map)

  end
end
