defmodule Aoc2015.Day02 do
  def paquet([l, w, h]) do
    papier = 2 * l * w + 2 * w * h + 2 * h * l
    papier + l * w
  end

  def ribbon([l, w, h]) do
    ribbon = l + l + w + w
    ribbon + l * w * h
  end

  defp prepareDim(dim) do
    dim
    |> String.trim()
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  def solution1(input) do
    input
    |> Stream.map(&prepareDim/1)
    |> Stream.map(&paquet/1)
    |> Enum.reduce(0, fn x, acc -> acc + x end)
  end

  def solution2(input) do
    input
    |> Stream.map(&prepareDim/1)
    |> Stream.map(&ribbon/1)
    |> Enum.reduce(0, fn x, acc -> acc + x end)
  end

  def part1 do
    File.stream!("./lib/day02/day02.txt")
    |> solution1
    |> IO.inspect(label: "Day02 Part 1 result : ")
  end

  def part2 do
    File.stream!("./lib/day02/day02.txt")
    |> solution2
    |> IO.inspect(label: "Day02 Part 2 result : ")
  end
end
