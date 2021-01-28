defmodule Aoc2015.Day01 do
  defp marche("("), do: 1
  defp marche(")"), do: -1

  def solution1(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reduce(0, fn x, acc -> acc + marche(x) end)
  end

  def solution2(input) do
    input
    |> String.split("", trim: true)
    |> Enum.reduce_while([0, 0], fn x, [charac, floor] ->
      if floor > -1, do: {:cont, [charac + 1, floor + marche(x)]}, else: {:halt, [charac, floor]}
    end)
    |> Enum.at(0)
  end

  def part1 do
    File.read!("./lib/day01/day01-1.txt")
    |> solution1
    |> IO.inspect(label: "Day01 Part 1 result : ")
  end

  def part2 do
    File.read!("./lib/day01/day01-2.txt")
    |> solution2
    |> IO.inspect(label: "Day01 Part 2 result : ")
  end
end
