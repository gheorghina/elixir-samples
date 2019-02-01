defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @space " "
  @em_ "_"
  @strong__ "__"
  @em_tag "em"
  @strong_tag "strong"
  @em_pattern ~r/_/
  @strong_pattern ~r/#{"__"}{1}/

  require Logger

  @spec parse(String.t()) :: String.t()
  def parse(text) do
    text |> process()
  end

  defp process(text) do
    cond do
      text |> String.starts_with?("#") and text |> String.contains?("*") -> text |> String.split("\n") |> process_all()
      text |> String.starts_with?("#") -> text |>  adjust_internals() |> enclose_with_header_tag()
      text |> String.starts_with?("*") -> text |>  adjust_internals() |> enclose_with_lists_tag()
      true -> text |>  adjust_internals() |> enclose_with_tag("p", @space)
    end
  end

  defp adjust_internals(text) do
    text
      |> String.split()
      |> replace_prefix()
      |> replace_suffix()
  end

  defp process_all([first_line | the_rest_of_the_text]) do
    first_line = first_line |> process()

    the_rest_of_the_text =
      the_rest_of_the_text
      |> Enum.join(@space)
      |> process()

    first_line <> the_rest_of_the_text
  end

  defp enclose_with_lists_tag([_ | words]) do
    words
    |> Enum.join(@space)
    |> String.split("*")
    |> Enum.map(fn w -> "<li>#{w |> String.trim()}</li>" end)
    |> enclose_with_tag("ul")
  end

  defp enclose_with_header_tag([hashes | words]) do
    h_tag_number = hashes |> String.length()

    words
    |> enclose_with_tag("h#{h_tag_number}", @space)
  end

  defp enclose_with_tag(words, tag, w_join \\"") do
    "<#{tag}>#{words |> Enum.join(w_join)}</#{tag}>"
end

  defp replace_prefix(words) when is_list(words) do
    words
    |> Enum.map(fn w ->
        w
        |> replace_prefix_md(@strong__, @strong_pattern, @strong_tag)
        |> replace_prefix_md(@em_, @em_pattern, @em_tag)
    end)
  end

  defp replace_suffix(words) when is_list(words) do
    words
    |> Enum.map(fn w ->
        w
        |> replace_suffix_md(@strong__, @strong_pattern, @strong_tag)
        |> replace_suffix_md(@em_, @em_pattern, @em_tag)
    end)
  end

  defp replace_prefix_md(word, condition, replace_pattern, tag) do
    cond do
      word |> String.starts_with?(condition) -> word |> String.replace(replace_pattern, "<#{tag}>", global: false)
      true -> word
    end
  end

  defp replace_suffix_md(word, condition, replace_pattern, tag) do
    cond do
      word |> String.ends_with?(condition) -> word |> String.replace(replace_pattern, "</#{tag}>")
      true -> word
    end
  end
end
