defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @of_beer_on_the_wall " of beer on the wall"
  @of_beer " of beer."
  @take_one_down "Take one down and pass it around, "
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
    #{@one_bottle}#{@of_beer_on_the_wall}, #{@one_bottle}#{@of_beer}
    #{@last_bottle_left_template}
    """
  end

  def verse(2) do
    """
    2 #{@bottles}#{@of_beer_on_the_wall}, 2 #{@bottles}#{@of_beer}
    #{@take_one_down}#{@one_bottle}#{@of_beer_on_the_wall}.
    """
  end

  def verse(n) do
    """
    #{n} #{@bottles}#{@of_beer_on_the_wall}, #{n} #{@bottles}#{@of_beer}
    #{@take_one_down}#{(n - 1)} #{@bottles}#{@of_beer_on_the_wall}.
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

  defp lyrics(n, acc) when n == 0, do: acc <> verse(n)
  defp lyrics(n, acc) when n > 0, do: acc <> verse(n) <> "\n"

end
