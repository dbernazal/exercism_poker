defmodule Poker.Rank do
  @rank_order ~w(2 3 4 5 6 7 8 9 10 J Q K A)

  def value(rank), do: Enum.find_index(@rank_order, &(&1 == rank))

  def highest_rank(%{cards: cards}) do
    cards
    |> Enum.map(& &1.rank)
    |> Enum.sort(fn first, next -> value(first) >= value(next) end)
    |> hd()
  end

  def highest_straight_rank(%{cards: cards}) do
    cards
    |> Enum.map(& &1.rank)
    |> Enum.sort(fn first, next -> value(first) >= value(next) end)
    |> swap_ace_low()
    |> hd()
  end

  def lowest_rank(%{cards: cards}) do
    cards
    |> Enum.map(& &1.rank)
    |> Enum.sort(fn first, next -> value(first) <= value(next) end)
    |> hd()
  end

  def highest_pair(hand),
    do:
      hand
      |> rank_histogram
      |> Enum.filter(fn {_key, value} -> value == 2 end)
      |> Enum.map(fn {rank, _count} -> rank end)
      |> Enum.sort(fn first, next -> value(first) >= value(next) end)
      |> hd()

  def lowest_pair(hand),
    do:
      hand
      |> rank_histogram
      |> Enum.filter(fn {_key, value} -> value == 2 end)
      |> Enum.map(fn {rank, _count} -> rank end)
      |> Enum.sort(fn first, next -> value(first) <= value(next) end)
      |> hd()

  def highest_triple(hand),
    do:
      hand
      |> rank_histogram
      |> Enum.filter(fn {_key, value} -> value == 3 end)
      |> Enum.map(fn {rank, _count} -> rank end)
      |> Enum.sort(fn first, next -> value(first) >= value(next) end)
      |> hd()

  def highest_quad(hand),
    do:
      hand
      |> rank_histogram
      |> Enum.filter(fn {_key, value} -> value == 4 end)
      |> Enum.map(fn {rank, _count} -> rank end)
      |> Enum.sort(fn first, next -> value(first) >= value(next) end)
      |> hd()

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
