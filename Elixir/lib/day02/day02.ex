defmodule Aoc2015.Day02 do
  @day "02"
  @input_file "./lib/day#{@day}/day#{@day}.txt"

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
    File.stream!(@input_file)
    |> solution1
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part2 do
    File.stream!(@input_file)
    |> solution2
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end
end
