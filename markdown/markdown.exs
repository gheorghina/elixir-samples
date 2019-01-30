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

  @spec parse(String.t()) :: String.t()
  def parse(m) do
    process(m)
  end

  defp process(t) do

    t
    |> String.split(@space)
    |> replace_prefix()
    |> replace_suffix()
    |> Enum.join(@space)
    |> enclose_with_paragraph_tag()

  end

  defp enclose_with_paragraph_tag(t) do
      "<p>#{t}</p>"
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


  # defp parse_header_md_level(hwt) do
  #   [h | t] = String.split(hwt)
  #   {to_string(String.length(h)), Enum.join(t, " ")}
  # end

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

  # defp enclose_with_header_tag({hl, htl}) do
  #   "<h" <> hl <> ">" <> htl <> "</h" <> hl <> ">"
  # end



  # defp join_words_with_tags(t) do
  #   Enum.join(Enum.map(t, fn w -> replace_md_with_tag(w) end), " ")
  # end

  # defp replace_md_with_tag(w) do
  #   w
  #   |> replace_prefix_md()
  #   |> replace_suffix_md()

  # end

  # defp replace_prefix_md(w) do
  #   cond do
  #     w =~ ~r/^#{"__"}{1}/ -> String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
  #     w =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(w, ~r/_/, "<em>", global: false)
  #     true -> w
  #   end
  # end

  # defp replace_suffix_md(w) do
  #   cond do
  #     w =~ ~r/#{"__"}{1}$/ -> String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
  #     w =~ ~r/[^#{"_"}{1}]/ -> String.replace(w, ~r/_/, "</em>")
  #     true -> w
  #   end
  # end

  # defp patch(l) do
  #   String.replace_suffix(
  #     String.replace(l, "<li>", "<ul>" <> "<li>", global: false),
  #     "</li>",
  #     "</li>" <> "</ul>"
  #   )
  # end
end
