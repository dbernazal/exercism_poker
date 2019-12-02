defmodule Poker.Analyzer do
  alias Poker.Rank

  def royal_flush(hand),
    do:
      has_straight?(hand) && has_flush?(hand) && Rank.highest_rank(hand) == "A" &&
        Rank.lowest_rank(hand) == "10"

  def straight_flush(hand), do: has_straight?(hand) && has_flush?(hand)
  def full_house(hand), do: has_pairs?(hand) && has_triples?(hand)

  def has_pairs?(hand),
    do: hand |> rank_histogram |> Map.values() |> Enum.count(&(&1 == 2)) |> Kernel.>(0)

  def has_two_pairs?(hand),
    do:
      hand
      |> rank_histogram
      |> Map.values()
      |> Enum.filter(&(&1 == 2))
      |> length()
      |> Kernel.==(2)

  def has_triples?(hand),
    do: hand |> rank_histogram |> Map.values() |> Enum.count(&(&1 == 3)) |> Kernel.>(0)

  def has_quads?(hand),
    do: hand |> rank_histogram |> Map.values() |> Enum.count(&(&1 == 4)) |> Kernel.>(0)

  def has_straight?(%{cards: cards}) do
    cards
    |> Enum.map(& &1.rank)
    |> Enum.sort(fn first, next -> Rank.value(first) >= Rank.value(next) end)
    |> swap_ace_low()
    |> is_straight?()
  end

  def has_flush?(%{cards: cards}),
    do: cards |> Enum.map(& &1.suit) |> Enum.uniq() |> Enum.count() == 1

  defp is_straight?([first, next | rest]),
    do: is_straight?(first, next) and is_straight?([next | rest])

  defp is_straight?(_), do: true

  defp is_straight?("2", "A"), do: true

  defp is_straight?(first, next),
    do: Rank.value(next) == Rank.value(first) - 1

  defp rank_histogram(%{cards: cards}),
    do:
      Enum.reduce(cards, %{}, fn card, accumulator ->
        {_, updated_count} = Map.get_and_update(accumulator, card.rank, &increment_rank_count/1)
        updated_count
      end)

  defp increment_rank_count(nil), do: {nil, 1}
  defp increment_rank_count(rank_count), do: {rank_count, rank_count + 1}

  defp swap_ace_low(["A", "5", "4", "3", "2"]), do: ["5", "4", "3", "2", "A"]
  defp swap_ace_low(value), do: value
end
