defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna("ACTG")
  "UGAC"
  """

  @adn_arn_complements %{g: ?C, c: ?G, t: ?A, a: ?U}

  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna
    |> Enum.map(fn v ->
      case v do
        ?G -> @adn_arn_complements[:g]
        ?C -> @adn_arn_complements[:c]
        ?T -> @adn_arn_complements[:t]
        ?A -> @adn_arn_complements[:a]
      end
    end)
  end
end
