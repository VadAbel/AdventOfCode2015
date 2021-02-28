defmodule Aoc2015.Day20 do
  @day 20
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  def present_house(presents_target, house \\ 1) do
    sqrt_house = house |> :math.sqrt() |> trunc()

    presents =
      1..sqrt_house
      |> Enum.flat_map(fn
        x when rem(house, x) != 0 -> []
        x when div(house, x) != x -> [x, div(house, x)]
        x -> [x]
      end)
      |> Enum.sum()
      |> Kernel.*(10)

    if presents < presents_target, do: present_house(presents_target, house + 1), else: house
  end

  def present_house2(presents_target, house \\ 1) do
    sqrt_house = house |> :math.sqrt() |> trunc()

    presents =
      1..sqrt_house
      |> Enum.flat_map(fn
        x when rem(house, x) != 0 -> []
        x when div(house, x) != x -> [x, div(house, x)]
        x -> [x]
      end)
      |> Enum.filter(&(div(house, &1) <= 50))
      |> Enum.sum()
      |> Kernel.*(11)

    if presents < presents_target, do: present_house2(presents_target, house + 1), else: house
  end

  def solution1(input) do
    input
    |> String.trim()
    |> String.to_integer()
    |> present_house()
  end

  def solution2(input) do
    input
    |> String.trim()
    |> String.to_integer()
    |> present_house2()
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
