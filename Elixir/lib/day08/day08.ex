defmodule Aoc2015.Day08 do
  @day "08"
  @input_file "../inputs/day#{@day}.txt"

  def decode(""), do: ""
  def decode(<<?\\, ?\\, tail::binary>>), do: <<?\\>> <> decode(tail)
  def decode(<<?\\, ?\", tail::binary>>), do: <<?\">> <> decode(tail)
  def decode(<<"\\x", _code::binary-size(2), tail::binary>>), do: <<"x">> <> decode(tail)
  def decode(<<char, tail::binary>>), do: <<char>> <> decode(tail)

  def encode(""), do: ""
  def encode(<<?\", tail::binary>>), do: <<?\\, ?\">> <> encode(tail)
  def encode(<<?\\, tail::binary>>), do: <<?\\, ?\\>> <> encode(tail)
  def encode(<<char, tail::binary>>), do: <<char>> <> encode(tail)

  def solution1(input) do
    input
    |> Stream.map(&String.trim(&1))
    |> Stream.map(fn x -> {x, String.trim(x, "\"")} end)
    |> Stream.map(fn {x, y} -> {x, decode(y)} end)
    |> Enum.reduce(0, fn {x, y}, acc -> String.length(x) - String.length(y) + acc end)
  end

  def solution2(input) do
    input
    |> Stream.map(&String.trim(&1))
    |> Stream.map(fn x -> {x, encode(x)} end)
    |> Enum.reduce(0, fn {x, y}, acc -> String.length(y) + 2 - String.length(x) + acc end)
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
