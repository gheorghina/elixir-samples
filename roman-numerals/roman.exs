defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """ 
  @numbers_representation %{ 1 => "I", 2 => "II", 3 => "III", 4 => "IV", 5 => "V", 
                             6 => "VI", 7 => "VII", 8 => "VIII", 9 => "IX", 10 => "X", 
                             50 => "L", 100 => "C", 500 => "D", 1000 => "M" }

  @division_margin 100 

  @lower_limit_pair %{ 50 => 10, 100 => 10, 500 => 100, 1000 => 100 }

  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do 
    
    cond do 
      number >= @division_margin -> do_no(number, @division_margin) 
      number < @division_margin -> do_no(number, @lower_limit_pair[@division_margin]) 
    end 

  end

  defp do_no(number, margin) do
    r_div = do_div(number, margin)
    r_mod = do_mod(number, margin)

    "#{r_div}#{r_mod}"
  end 

  defp do_mod(number, margin) do
    mod = round(:math.fmod(number, margin))

    cond do
      mod == 0 -> ""      
      mod != 0 -> @numbers_representation[mod]
    end
  end

  defp do_div(number, margin) do
    div = round(:math.floor(number/margin))
    r_margin_mid_upper = @numbers_representation[margin * 5] 
    r_margin_upper =  @numbers_representation[margin * margin] 
    r_margin =  @numbers_representation[margin] 

    cond do
      div == 0 -> ""
      div <= 3 -> do_repetive(div, margin)
      div == 4 -> "#{r_margin}#{r_margin_mid_upper}"
      div == 5 -> "#{r_margin_mid_upper}"
      div > 5 and div <= 8 -> "#{r_margin_mid_upper}#{do_repetive(div, margin)}"
      div == 9 -> "#{r_margin}#{r_margin_mid_upper}"
    end
  end 

  defp do_repetive(div, margin) do
     1..div
     |> Enum.map(fn n -> @numbers_representation[margin] end)
     |> Enum.join 

  end 

end

#
# X, XX, XXX, XL, L, LX, LXX, LXXX, XC, C
# C, CC, CCC, CD, D, DC, DCC, DCCC, CM, M
# 39 = "Thirty nine" (XXX+IX) = XXXIX.
# 246 = "Two hundred and forty six" (CC+XL+VI) = CCXLVI.
# 1776 (M+DCC+LXX+VI) = MDCCLXXVI (the date written on the book held by the Statue of Liberty).[5]
# 1954 (M+CM+L+IV) = MCMLIV (as in the trailer for the movie The Last Time I Saw Paris)[6]
# 1990 (M+CM+XC) = MCMXC (used as the title of musical project Enigma's debut album MCMXC a.D., named after the year of its release).
# 2014 (MM+X+IV) = MMXIV (the year of the games of the XXII (22nd) Olympic Winter Games (in Sochi)
# The current year (2018) is MMXVIII.


