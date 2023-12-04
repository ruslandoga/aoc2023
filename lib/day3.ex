defmodule Day3 do
  # https://adventofcode.com/2023/day/3

  def input do
    File.stream!("priv/day3.txt")
  end

  def example_input do
    String.split(
      """
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..\
      """,
      "\n"
    )
  end

  defp process_input(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{numbers: %{}, symbols: %{}}, fn {line, y}, acc ->
      # IO.puts(line)
      {numbers, symbols} = process_line(line)

      numbers =
        Enum.reduce(numbers, acc.numbers, fn {number, x}, acc -> Map.put(acc, {x, y}, number) end)

      symbols =
        Enum.reduce(symbols, acc.symbols, fn {symbol, x}, acc -> Map.put(acc, {x, y}, symbol) end)

      # IO.inspect(numbers, label: "numbers")
      # IO.inspect(symbols, label: "symbols")
      %{acc | numbers: numbers, symbols: symbols}
    end)
  end

  def process_line(line) do
    process_line(line, _x = 0, _numbers = [], _symbols = [])
  end

  defp process_line(<<n, _::bytes>> = bin, x, numbers, symbols) when n >= ?0 and n <= ?9 do
    {i, rest} = Integer.parse(bin)

    process_line(
      rest,
      x + byte_size(bin) - byte_size(rest),
      [{Integer.to_string(i), x} | numbers],
      symbols
    )
  end

  defp process_line(<<?., rest::bytes>>, x, numbers, symbols) do
    process_line(rest, x + 1, numbers, symbols)
  end

  defp process_line(<<?\n>>, _x, numbers, symbols), do: {numbers, symbols}

  defp process_line(<<symbol, rest::bytes>>, x, numbers, symbols) do
    process_line(rest, x + 1, numbers, [{symbol, x} | symbols])
  end

  defp process_line(<<>>, _x, numbers, symbols), do: {numbers, symbols}

  @doc """
      iex> part1(example_input())
      4361

      iex> part1(input())
      530495
  """
  def part1(input) do
    %{numbers: numbers, symbols: symbols} = process_input(input)

    filter_adjacent(numbers, symbols)
    |> Enum.map(fn {_xy, number} -> String.to_integer(number) end)
    |> Enum.sum()
  end

  defp filter_adjacent(numbers, symbols) do
    Enum.reject(numbers, fn {{x, y}, number} ->
      len = byte_size(number)

      adjacent_symbols =
        for x <- (x - 1)..(x + len),
            y <- (y - 1)..(y + 1),
            Map.has_key?(symbols, {x, y}),
            do: Map.fetch!(symbols, {x, y})

      adjacent_symbols == []
    end)
  end

  @doc """
      iex> part2(example_input())
      467835

      iex> part2(input())
      80253814
  """
  def part2(input) do
    %{numbers: numbers, symbols: symbols} = process_input(input)
    get_gears(numbers, symbols)
  end

  defp get_gears(numbers, symbols) do
    numbers_bitmap =
      Enum.reduce(numbers, %{}, fn {{x, y}, number}, acc ->
        xs = x..(x + byte_size(number) - 1)

        Enum.reduce(xs, acc, fn new_x, acc ->
          Map.put(acc, {new_x, y}, {{x, y}, number})
        end)
      end)

    Enum.reduce(symbols, 0, fn {{x, y}, symbol}, acc ->
      if symbol == ?* do
        numbers =
          for x <- (x - 1)..(x + 1),
              y <- (y - 1)..(y + 1),
              Map.has_key?(numbers_bitmap, {x, y}),
              do: Map.fetch!(numbers_bitmap, {x, y})

        case Enum.uniq(numbers) do
          [{_, n1}, {_, n2}] -> String.to_integer(n1) * String.to_integer(n2) + acc
          [_] -> acc
          [] -> acc
        end
      else
        acc
      end
    end)
  end
end
