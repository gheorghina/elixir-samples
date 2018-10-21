defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @verse1_template_p1 " of beer on the wall, "
  @verse1_template_p2 " of beer."
  @verse2_template_p1 "Take one down and pass it around, "
  @verse2_template_p2 " of beer on the wall."
  @last_bottle_left_template "Take it down and pass it around, no more bottles of beer on the wall."
  @last_verse "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall."
  @bottles "bottles"
  @one_bottle "1 bottle"

  @spec verse(integer) :: String.t()
  def verse(0) do 
    """
    #{@last_verse}
    """ 
  end 

  def verse(1) do 
    """
    #{@one_bottle}#{@verse1_template_p1}#{@one_bottle}#{@verse1_template_p2}
    #{@last_bottle_left_template}
    """
  end 

  def verse(n) do  

    bottles = "#{n} #{@bottles}"       
                    
    left_bottles = 
      case n do
        2 -> @one_bottle
        _ -> "#{( n - 1)} #{@bottles}"
      end
    
    """
    #{bottles}#{@verse1_template_p1}#{bottles}#{@verse1_template_p2}
    #{@verse2_template_p1}#{left_bottles}#{@verse2_template_p2}
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
   for n <- range do lyrics(n, "") end
    |> to_string()
  end

  def lyrics(n, acc) when n > 0, do: acc <> verse(n) <> "\n"
  def lyrics(n, acc) when n == 0, do: acc <> verse(n)
end
