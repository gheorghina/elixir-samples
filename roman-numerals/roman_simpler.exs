defmodule Roman2 do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(0), do: ""
  def numerals(n) when n >= 1000, do: "M" <> numerals(n-1000)
  def numerals(n) when n >= 900, do: "CM" <> numerals(n-900)
  def numerals(n) when n >= 500, do: "D" <> numerals(n-500)
  def numerals(n) when n >= 400, do: "CD" <> numerals(n-400)
  def numerals(n) when n >= 100, do: "C" <> numerals(n-100)
  def numerals(n) when n >= 90, do: "XC" <> numerals(n-90)
  def numerals(n) when n >= 50, do: "L" <> numerals(n-50)
  def numerals(n) when n >= 40, do: "XL" <> numerals(n-40)
  def numerals(n) when n >= 10, do: "X" <> numerals(n-10)
  def numerals(n) when n >= 9, do: "IX" <> numerals(n-9)
  def numerals(n) when n >= 5, do: "V" <> numerals(n-5)
  def numerals(n) when n >= 4, do: "IV" <> numerals(n-4)
  def numerals(n), do: "I" <> numerals(n-1)
end
