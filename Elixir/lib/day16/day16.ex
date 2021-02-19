defmodule Aoc2015.Day16 do
  @day 16
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  import NimbleParsec

  @indices %{
    "children" => 3,
    "cats" => 7,
    "samoyeds" => 2,
    "pomeranians" => 3,
    "akitas" => 0,
    "vizslas" => 0,
    "goldfish" => 5,
    "trees" => 3,
    "cars" => 2,
    "perfumes" => 1
  }

  compound =
    eventually(ascii_string([?a..?z], min: 1))
    |> eventually(integer(min: 1, max: 2))
    |> wrap()

  aunt_sue =
    ignore(string("Sue"))
    |> eventually(integer(min: 1, max: 3))
    |> times(compound, 3)

  defparsec(:aunt_sue, aunt_sue)

  def parse_aunt_sue(input) do
    Enum.map(input, fn x ->
      {:ok, result, _, _, _, _} = aunt_sue(x)
      result
    end)
  end

  def test?(list) do
    list
    |> Enum.reduce(true, fn [compound, count], acc -> count == @indices[compound] and acc end)
  end

  def test2?(list) do
    list
    |> Enum.reduce(true, fn
      [compound, count], acc when compound in ["cats", "trees"] ->
        count > @indices[compound] and acc

      [compound, count], acc when compound in ["pomeranians", "goldfish"] ->
        count < @indices[compound] and acc

      [compound, count], acc ->
        count == @indices[compound] and acc
    end)
  end

  def solution1(input) do
    input
    |> parse_aunt_sue
    |> Enum.reduce([], fn [id | list], acc -> if test?(list), do: [id | acc], else: acc end)
    |> hd()
  end

  def solution2(input) do
    input
    |> parse_aunt_sue
    |> Enum.reduce([], fn [id | list], acc -> if test2?(list), do: [id | acc], else: acc end)
    |> hd()
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
