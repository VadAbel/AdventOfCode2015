defmodule Aoc2015.Day03 do
  def move({x, y}, "^"), do: {x, y + 1}
  def move({x, y}, ">"), do: {x + 1, y}
  def move({x, y}, "v"), do: {x, y - 1}
  def move({x, y}, "<"), do: {x - 1, y}

  def delivery(parcour) do
    parcour
    |> Enum.reduce([{0, 0}], fn x, [h | t] -> [move(h, x) | [h | t]] end)
  end

  def solution1(input) do
    input
    |> String.split("", trim: true)
    |> delivery()
    |> Enum.uniq()
    |> Enum.count()
  end

  def solution2(input) do
    input
    |> String.split("", trim: true)
    |> Enum.chunk_every(2)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.flat_map(&delivery/1)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part1 do
    File.read!("./lib/day03/day03.txt")
    |> solution1
    |> IO.inspect(label: "Day03 Part 1 result : ")
  end

  def part2 do
    File.read!("./lib/day03/day03.txt")
    |> solution2
    |> IO.inspect(label: "Day03 Part 2 result : ")
  end
end
