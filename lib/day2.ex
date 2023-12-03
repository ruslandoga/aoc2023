defmodule Day2 do
  # https://adventofcode.com/2023/day/2

  def input do
    File.stream!("priv/day2.txt")
  end

  def example_input do
    String.split(
      """
      Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
      Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
      Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
      Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green\
      """,
      "\n"
    )
  end

  defp process_input(input) do
    Enum.map(input, fn line ->
      ["Game " <> id | sets] = line |> String.trim() |> String.split([":", ";"])

      sets =
        Enum.map(sets, fn set ->
          set
          |> String.split(",")
          |> Enum.map(&String.trim/1)
          |> Enum.map(fn sample ->
            [n, color] = String.split(sample, " ")
            {color, String.to_integer(n)}
          end)
        end)

      {String.to_integer(id), sets}
    end)
  end

  @doc """
      iex> part1(example_input())
      8

      iex> part1(input())
      2716

  """
  def part1(input) do
    input
    |> process_input()
    |> Enum.map(fn {id, set} ->
      possible? =
        Enum.all?(set, fn sample ->
          Enum.all?(sample, fn {color, count} ->
            case color do
              "red" -> count <= 12
              "green" -> count <= 13
              "blue" -> count <= 14
            end
          end)
        end)

      if possible?, do: id, else: 0
    end)
    |> Enum.sum()
  end

  @doc """
      iex> part2(example_input())
      2286

      iex> part2(input())
      72227

  """
  def part2(input) do
    input
    |> process_input()
    |> Enum.map(fn {_id, set} ->
      %{"red" => red, "green" => green, "blue" => blue} =
        Enum.reduce(set, %{"red" => 0, "green" => 0, "blue" => 0}, fn sample, acc ->
          Enum.reduce(sample, acc, fn {color, n}, acc ->
            prev_n = Map.fetch!(acc, color)
            if prev_n < n, do: Map.put(acc, color, n), else: acc
          end)
        end)

      red * green * blue
    end)
    |> Enum.sum()
  end
end
