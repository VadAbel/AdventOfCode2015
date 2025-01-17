defmodule Aoc2015.Day04 do
  @day "04"
  @input_file "../inputs/day#{@day}.txt"

  def find_number(input, nb_zero, number \\ 1) do
    hash = :crypto.hash(:md5, input <> Integer.to_string(number)) |> Base.encode16()

    if String.slice(hash, 0..(nb_zero - 1)) == String.duplicate("0", nb_zero) do
      number
    else
      find_number(input, nb_zero, number + 1)
    end
  end

  def solution1(input) do
    find_number(input, 5)
  end

  def solution2(input) do
    find_number(input, 6)
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
