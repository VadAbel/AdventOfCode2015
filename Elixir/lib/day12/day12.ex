defmodule Aoc2015.Day12 do
  @day "12"
  @input_file "../inputs/day#{@day}.txt"

  def parse(obj) when is_map(obj), do: Map.values(obj) |> parse()
  def parse(obj) when is_list(obj), do: Enum.map(obj, &parse(&1))
  def parse(obj) when is_integer(obj), do: obj
  def parse(_obj), do: []

  def parse2(obj) when is_map(obj) do
    if "red" in Map.values(obj) do
      []
    else
      Map.values(obj) |> parse2()
    end
  end

  def parse2(obj) when is_list(obj), do: Enum.map(obj, &parse2(&1))
  def parse2(obj) when is_integer(obj), do: obj
  def parse2(_obj), do: []

  def solution1(input) do
    input
    |> Jason.decode!()
    |> parse
    |> List.flatten()
    |> Enum.sum()
  end

  def solution2(input) do
    input
    |> Jason.decode!()
    |> parse2
    |> List.flatten()
    |> Enum.sum()
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
