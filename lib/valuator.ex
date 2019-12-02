defmodule Poker.Valuator do
  alias Poker.Rank

  def value(_hand, :royal_flush), do: [9]

  def value(hand, :straight_flush), do: [8, hand |> Rank.highest_rank() |> Rank.value()]

  def value(hand, :quads),
    do: [
      7,
      hand |> Rank.highest_quad() |> Rank.value(),
      hand |> Rank.highest_rank() |> Rank.value()
    ]

  def value(hand, :full_house),
    do: [
      6,
      hand |> Rank.highest_triple() |> Rank.value(),
      hand |> Rank.highest_pair() |> Rank.value()
    ]

  def value(hand, :flush),
    do: [[5] | value_singles(hand)] |> List.flatten()

  def value(hand, :straight), do: [4, hand |> Rank.highest_straight_rank() |> Rank.value()]

  def value(hand, :triples),
    do:
      [[3, hand |> Rank.highest_triple() |> Rank.value()] | value_singles(hand)]
      |> List.flatten()

  def value(hand, :two_pairs),
    do:
      [
        [
          2,
          hand |> Rank.highest_pair() |> Rank.value(),
          hand |> Rank.lowest_pair() |> Rank.value()
        ]
        | value_singles(hand)
      ]
      |> List.flatten()

  def value(hand, :pairs),
    do:
      [
        [1, hand |> Rank.highest_pair() |> Rank.value()]
        | value_singles(hand)
      ]
      |> List.flatten()

  def value(%{cards: cards}, :high_card),
    do: [0 | Enum.map(cards, &Rank.value(&1.rank)) |> Enum.sort() |> Enum.reverse()]

  def compare(first, next) when is_list(first) and is_list(next),
    do:
      Enum.zip(first, next)
      |> Enum.drop_while(fn {a, b} -> a == b end)
      |> compare_tuple()

  defp value_singles(hand),
    do:
      hand
      |> extract_singles()
      |> Enum.map(&Rank.value(&1.rank))
      |> Enum.sort()
      |> Enum.reverse()

  defp extract_singles(%{cards: cards}),
    do:
      cards
      |> Enum.group_by(& &1.rank)
      |> Enum.filter(fn {_key, value} -> length(value) <= 1 end)
      |> Enum.map(fn {_, cards} -> cards end)
      |> List.flatten()

  defp compare_tuple([]), do: false
  defp compare_tuple([{a, b} | _rest]), do: a > b
end
