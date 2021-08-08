defmodule Aoc2015.Day10 do
  @day "10"
  @input_file "../inputs/day#{@day}.txt"

  def process(list, time) do
    Stream.iterate(list, fn x ->
      x
      |> Enum.chunk_by(& &1)
      |> List.foldr([], &[Enum.count(&1), hd(&1) | &2])
    end)
    |> Enum.at(time)
  end

  defp parse_input(input) do
    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def solution1(input) do
    input
    |> parse_input()
    |> process(40)
    |> Enum.count()
  end

  def solution2(input) do
    input
    |> parse_input()
    |> process(50)
    |> Enum.count()
  end

  def part1 do
    File.read!(@input_file)
    |> solution1
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part2 do
    File.read!(@input_file)
    |> solution2
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end
end
