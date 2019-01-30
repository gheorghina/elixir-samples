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
  def parse(m) do
    process(m)
  end

  defp process(t) do
    words =
            t
            |> String.split()
            |> replace_prefix()
            |> replace_suffix()

    cond do
      t |> String.starts_with?("#") -> words |> enclose_with_header_tag()
      true -> words |> enclose_with_paragraph_tag()
    end
  end

  defp enclose_with_header_tag([h | t]) do
    h_no = h |> String.length()
    text = t |> Enum.join(@space)

    "<h#{h_no}>#{text}</h#{h_no}>"
  end

  defp enclose_with_paragraph_tag(words) do
      "<p>#{words |> Enum.join(@space)}</p>"
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


  # defp parse_list_md_level(l) do

  #   l
  #   |> String.split()
  #   |> replace_md_with_tag()
  #   |> Enum.join(" ")


  #   # t = String.split(String.trim_leading(l, "* "))
  #   # "<li>" <> join_words_with_tags(t) <> "</li>"

  #   # l
  #   # |> String.split(~r/\s/)
  #   # |> replace_md_with_tag()

  # end

  # defp patch(l) do
  #   String.replace_suffix(
  #     String.replace(l, "<li>", "<ul>" <> "<li>", global: false),
  #     "</li>",
  #     "</li>" <> "</ul>"
  #   )
  # end
end
