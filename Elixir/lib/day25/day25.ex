defmodule Aoc2015.Day25 do
  @day 25
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  def next_code(code), do: rem(code * 252_533, 33_554_393)

  def next_coord({1, col}), do: {col + 1, 1}
  def next_coord({row, col}), do: {row - 1, col + 1}

  def find_code(target, coord \\ {1, 1}, code \\ 20_151_125)
  def find_code(target, coord, code) when target == coord, do: code
  def find_code(target, coord, code), do: find_code(target, next_coord(coord), next_code(code))

  def parse(input) do
    Regex.scan(~r/\d+/, input, capture: :all)
    |> Enum.map(fn [x] -> String.to_integer(x) end)
    |> List.to_tuple()
  end

  def solution1(input) do
    input
    |> parse()
    |> find_code()
  end

  def part1 do
    File.read!(@input_file)
    |> solution1
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end
end
