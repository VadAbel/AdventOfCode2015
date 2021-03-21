defmodule Aoc2015.Day17 do
  @day "17"
  @input_file "../inputs/day#{@day}.txt"

  @max_container 150

  def combinaison([], 0), do: [[]]

  def combinaison(container_list, size_to_fill) do
    for x <- 1..length(container_list),
        container = Enum.at(container_list, x - 1),
        rest = size_to_fill - container,
        rest >= 0,
        {_, rest_container} = Enum.split(container_list, x),
        y <- combinaison(Enum.filter(rest_container, &(&1 <= rest)), rest) do
      [container | y]
    end
  end

  def solution1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> combinaison(@max_container)
    |> Enum.count()
  end

  def solution2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> combinaison(@max_container)
    |> Enum.map(&length(&1))
    |> (&Enum.filter(&1, fn x -> x == Enum.min(&1) end)).()
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
