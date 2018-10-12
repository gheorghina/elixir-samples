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
    |> Enum.filter(fn m -> (number >= m and number < m * 10) or ( m == 10 and number < m) end)
    |> Enum.map(fn m -> do_no(number, m) end)
    |> Enum.join 

  end

  defp do_no(number, margin) do
    div = round(:math.floor(number/margin))
    mod = round(:math.fmod(number, margin))    
    
    r_mod = cond do
              mod == 0 -> ""       
              margin != 10 and mod > margin / 10 -> do_no(mod, round(margin/10))
              margin == 10 -> @numbers_representation[mod]
            end
    
    r_div = cond do
              div == 0 -> "" 
              div <= 3 -> do_repetive(div, margin)
              div == 4 -> "#{@numbers_representation[margin]}#{@numbers_representation[margin * 5]}"
              div == 5 -> "#{@numbers_representation[margin * 5]}"    
              div > 5 and div <= 8 -> "#{ @numbers_representation[margin * 5]}#{do_repetive(div, margin)}"  
              div == 9 -> "#{ @numbers_representation[margin]}#{ @numbers_representation[margin * 10]}"              
            end

    "#{r_div}#{r_mod}"
  end

  defp do_repetive(div, margin) do
     1..div
     |> Enum.map(fn n -> @numbers_representation[margin] end)
     |> Enum.join 
  end 

end



