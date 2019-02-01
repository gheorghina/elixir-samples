defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown_string) do
    markdown_string
    |> String.split("\n")
    |> Enum.map_join(&process_lines/1)
    |> bold
    |> emphasize
    |> wrap_lists
  end

  defp process_lines("#" <> string),  do: string |> add_header_tag(1)
  defp process_lines("* " <> string), do: string |> add_tag("li")
  defp process_lines(string),         do: string |> add_tag("p")

  defp add_tag(string, tag), do: "<#{tag}>#{string}</#{tag}>"

  defp add_header_tag(" " <> string, level), do: string |> add_tag("h#{level}")
  defp add_header_tag("#" <> string, level), do: add_header_tag(string, level + 1)

  defp bold(string), do: string |> String.replace(~r/__([^_]+)__/, "<strong>\\1</strong>")
  defp emphasize(string), do: string |> String.replace(~r/_([^_]+)_/, "<em>\\1</em>")
  defp wrap_lists(string), do: string |> String.replace(~r/<li>(.*)<\/li>/, "<ul><li>\\1</li></ul>")
end
