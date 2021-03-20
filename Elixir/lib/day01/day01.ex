defmodule Aoc2015.Day01 do
  @day "01"
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  defp marche("("), do: 1
  defp marche(")"), do: -1

  def solution1(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reduce(0, fn x, acc -> marche(x) + acc end)
  end

  def solution2(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reduce_while([0, 0], fn x, [charac, floor] ->
      if floor > -1,
        do: {:cont, [charac + 1, floor + marche(x)]},
        else: {:halt, [charac, floor]}
    end)
    |> Enum.at(0)
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
