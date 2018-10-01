defmodule Bob do
  def hey(input) do
    cond do

      #empty
      Regex.match?(~r/^\z/, input) -> "Fine. Be that way!"

      #prolonged silence
      Regex.match?(~r/^\s*\z/, input) -> "Fine. Be that way!"

      # question with numbers
      Regex.match?(~r/^[0-9]*\?\z/, input) -> "Sure."

      # shoutting followed by ?
      Regex.match?(~r/^[^a-z]*\?\z/, input) -> "Calm down, I know what I'm doing!"

      #only numbers separated by comman and space
      Regex.match?(~r/\p{Nd}\,\s\p{Nd}\z/, input) -> "Whatever."

      #talking in capitals | shouting with special characters inclusing russian /[\x{0410}-\x{042F}]/u
      Regex.match?(~r/^[^a-z]*\z/, input) -> "Whoa, chill out!"

      #asking a question |
      Regex.match?(~r/(.*)\?\z/, input) -> "Sure."

      #statement containing question mark
      Regex.match?(~r/\?/, input) -> "Whatever."

      Regex.match?(~r/(.*)\.\z/, input) -> "Whatever."

      #talking forcefully | talking in capitals
      Regex.match?(~r/(.*)\!\z/, input) -> "Whatever."

      #only numbers | the rest
      true -> "Whatever."

    end
  end
end



