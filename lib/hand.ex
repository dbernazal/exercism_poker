defmodule Poker.Hand do
  alias Poker.Analyzer
  alias Poker.Valuator

  @enforce_keys [:cards]
  defstruct [:cards]

  def from_string_list(cards), do: %__MODULE__{cards: Enum.map(cards, &Poker.Card.from_string/1)}

  def to_string_list(%{cards: cards}),
    do: cards |> Enum.map(&Poker.Card.to_string/1)

  def value(hand) do
    cond do
      Analyzer.royal_flush(hand) ->
        Valuator.value(hand, :royal_flush)

      Analyzer.straight_flush(hand) ->
        Valuator.value(hand, :straight_flush)

      Analyzer.has_quads?(hand) ->
        Valuator.value(hand, :quads)

      Analyzer.full_house(hand) ->
        Valuator.value(hand, :full_house)

      Analyzer.has_flush?(hand) ->
        Valuator.value(hand, :flush)

      Analyzer.has_straight?(hand) ->
        Valuator.value(hand, :straight)

      Analyzer.has_triples?(hand) ->
        Valuator.value(hand, :triples)

      Analyzer.has_two_pairs?(hand) ->
        Valuator.value(hand, :two_pairs)

      Analyzer.has_pairs?(hand) ->
        Valuator.value(hand, :pairs)

      true ->
        Valuator.value(hand, :high_card)
    end
  end
end
