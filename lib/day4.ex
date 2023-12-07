defmodule Day4 do
  # https://adventofcode.com/2023/day/4

  def input do
    File.stream!("priv/day4.txt")
  end

  def example_input do
    String.split(
      """
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\
      """,
      "\n"
    )
  end

  defp process_input(input) do
    Enum.map(input, fn line ->
      line = String.replace_trailing(line, "\n", "")
      ["Card " <> card_id, numbers] = String.split(line, ":")
      card_id = String.to_integer(String.trim(card_id))
      [winning, mine] = String.split(numbers, "|")
      winning = winning |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      mine = mine |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      %{id: card_id, winning: winning, mine: mine}
    end)
  end

  @doc """
      iex> part1(example_input())
      13

      iex> part1(input())
      33950
  """
  def part1(input) do
    process_input(input)
    |> Enum.map(fn card ->
      matches = Enum.count(card.mine, fn number -> number in card.winning end)

      case matches do
        0 -> 0
        _ -> :math.pow(2, matches - 1)
      end
    end)
    |> Enum.sum()
    |> round()
  end

  @doc """
      iex> part2(example_input())
      30

      iex> part2(input())
      14814534
  """
  def part2(input) do
    cards = process_input(input)
    copied_cards = Map.new(cards, &{&1.id, 0})

    copied_cards =
      Enum.reduce(cards, copied_cards, fn card, acc ->
        matches = Enum.count(card.mine, &(&1 in card.winning))

        case matches do
          0 ->
            acc

          _ ->
            ids = (card.id + 1)..(card.id + matches)
            multiplier = Map.fetch!(acc, card.id)
            Enum.reduce(ids, acc, fn id, acc -> Map.update!(acc, id, &(&1 + multiplier + 1)) end)
        end
      end)

    Enum.reduce(copied_cards, 0, fn {_id, copies}, acc -> acc + copies + 1 end)
  end
end
