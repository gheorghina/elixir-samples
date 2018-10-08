defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """

  @numbers_representation %{ 1 => "I", 2 => "II", 3 => "III", 4 => "IV", 5 => "V", 6 => "VI", 7 => "VII", 8 => "VIII", 9 => "IX", 10 => "X", 50 => "L", 100 => "C", 500 => "D", 1000 => "M" }
  @limits [10]

  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do

    @limits
    |> Enum.map(fn n -> do_parse_no(n, number) end)
    |> Enum.join()

  end

  defp do_parse_no(margin, number) do

    div = round(:math.floor(number/margin))
    mod = round(:math.fmod(number, margin))

    r_div = roman_for_div(div, margin)
    r_mod = roman_for_mod(mod)

    "#{r_div}#{r_mod}"

  end

  defp roman_for_div(number, margin) do
    cond do
      number == 0 -> ""
      number < 10 -> do_get_values(number, margin)
    end
  end

  defp do_get_values(no, margin) do

    1..no
    |> Enum.map(fn n -> @numbers_representation[margin] end)
    |> Enum.join

  end

  defp roman_for_mod(number) do
    cond do
      number == 0 -> ""
      number <= 10 -> @numbers_representation[number]
    end
  end

end

# X, XX, XXX, XL, L, LX, LXX, LXXX, XC, C
# C, CC, CCC, CD, D, DC, DCC, DCCC, CM, M
# 39 = "Thirty nine" (XXX+IX) = XXXIX.
# 246 = "Two hundred and forty six" (CC+XL+VI) = CCXLVI.
# 1776 (M+DCC+LXX+VI) = MDCCLXXVI (the date written on the book held by the Statue of Liberty).[5]
# 1954 (M+CM+L+IV) = MCMLIV (as in the trailer for the movie The Last Time I Saw Paris)[6]
# 1990 (M+CM+XC) = MCMXC (used as the title of musical project Enigma's debut album MCMXC a.D., named after the year of its release).
# 2014 (MM+X+IV) = MMXIV (the year of the games of the XXII (22nd) Olympic Winter Games (in Sochi)
# The current year (2018) is MMXVIII.


