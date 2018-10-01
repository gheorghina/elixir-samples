defmodule BobSimpler do
  def hey(input) do
    cond do
      silence?(input) -> "Fine. Be that way."
      question?(input) -> "Sure."
      shouting?(input) -> "Woah, chill out!"
      true -> "Whatever."
    end
  end

  defp silence?(input), do: empty?(input)

  defp question?(input), do: String.ends_with?(input, "?")

  defp shouting?(input), do: has_letters?(input) && all_caps?(input)

  defp all_caps?(input), do: String.upcase(input) == input

  defp has_letters?(input), do: Regex.match?(%r/\p{L}/, input)

  defp empty?(input), do: String.length(String.strip(input)) == 0
end
