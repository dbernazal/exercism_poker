defmodule Poker.Card do
  @enforce_keys [:suit, :rank]
  defstruct [:suit, :rank]

  def from_string(values) do
    [rank, suit] =
      case String.codepoints(values) do
        [rank, suit] -> [rank, suit]
        # Handle the rank "10". Codepoints will separate 10 into ["1", "0"]
        [digit1, digit2, suit] -> [digit1 <> digit2, suit]
      end

    %__MODULE__{suit: suit, rank: rank}
  end

  def to_string(%{suit: suit, rank: rank}), do: rank <> suit
end
