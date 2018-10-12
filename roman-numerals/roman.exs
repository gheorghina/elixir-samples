defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """ 
  @numbers_representation %{ 1 => "I", 2 => "II", 3 => "III", 4 => "IV", 5 => "V", 
                             6 => "VI", 7 => "VII", 8 => "VIII", 9 => "IX", 10 => "X", 
                             50 => "L", 100 => "C", 500 => "D", 1000 => "M" }

  @division_margins [1000, 100, 10]

  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do 
    
    @division_margins
    |> Enum.map(fn m -> do_no(number, m)  end)
    |> Enum.join 

  end

  defp do_no(number, margin) do

    r_mod = cond do
          margin == 10 -> do_mod(number, margin) 
          margin != 10 -> ""       
        end

    r_div = cond do
          number >= margin and number < margin * 10 -> do_div(number, margin)
          number < margin -> ""       
        end

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
      div == 9 -> "#{r_margin}#{r_margin_upper}" 
    end
  end 

  defp do_repetive(div, margin) do
     1..div
     |> Enum.map(fn n -> @numbers_representation[margin] end)
     |> Enum.join 

  end 

end



