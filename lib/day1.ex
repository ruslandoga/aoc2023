defmodule Day1 do
  # https://adventofcode.com/2023/day/1

  def input do
    File.stream!("priv/day1.txt")
  end

  def example_input do
    String.split("""
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet\
    """)
  end

  defp process_input(input) do
    Enum.map(input, &String.trim/1)
  end

  @doc """
      iex> part1(example_input())
      142

      iex> part1(input())
      55029

  """
  def part1(input) do
    input
    |> process_input()
    |> Enum.map(&number/1)
    |> Enum.sum()
  end

  defp number(line) do
    number(line, nil, nil)
  end

  defp number(<<n, rest::bytes>>, n1, n2) when n >= ?0 and n <= ?9 do
    n = n - ?0

    if n1 do
      number(rest, n1, n)
    else
      number(rest, n, n2)
    end
  end

  defp number(<<_, rest::bytes>>, n1, n2), do: number(rest, n1, n2)
  defp number(<<>>, n1, n2), do: n1 * 10 + (n2 || n1)

  @doc """
      iex> part2(example_input2())
      281

      iex> part2(input())
      55686

  """
  def part2(input) do
    input
    |> process_input()
    |> Enum.map(&number_alpha/1)
    |> Enum.sum()
  end

  def example_input2 do
    String.split("""
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen\
    """)
  end

  defp number_alpha(line) do
    number_alpha(line, nil, nil)
  end

  alpha = %{
    "zero" => 0,
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  for {a, n} <- alpha do
    defp number_alpha(unquote(a) <> _ = line, n1, n2) do
      <<_, rest::bytes>> = line

      if n1 do
        number_alpha(rest, n1, unquote(n))
      else
        number_alpha(rest, unquote(n), n2)
      end
    end
  end

  defp number_alpha(<<n, rest::bytes>>, n1, n2) when n >= ?0 and n <= ?9 do
    n = n - ?0

    if n1 do
      number_alpha(rest, n1, n)
    else
      number_alpha(rest, n, n2)
    end
  end

  defp number_alpha(<<_, rest::bytes>>, n1, n2), do: number_alpha(rest, n1, n2)
  defp number_alpha(<<>>, n1, n2), do: n1 * 10 + (n2 || n1)
end
