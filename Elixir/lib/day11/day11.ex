defmodule Aoc2015.Day11 do
  @day "11"
  @input_file "../inputs/day#{@day}.txt"

  def is_valid_password(password),
    do: include_straight(password) && has_valid_char(password) && has_two_pair(password)

  def include_straight(password) when byte_size(password) < 3, do: false
  def include_straight(<<x, y, z, _rest::binary>>) when z == y - 1 and y == x - 1, do: true
  def include_straight(<<_x, y, z, rest::binary>>), do: include_straight(<<y, z, rest::binary>>)

  def has_valid_char(password),
    do: not String.contains?(password, :binary.compile_pattern(["i", "o", "l"]))

  def has_two_pair(password), do: count_pair(password) >= 2

  defp count_pair(password) when byte_size(password) < 2, do: 0
  defp count_pair(<<x, y, rest::binary>>) when x == y, do: 1 + count_pair(rest)
  defp count_pair(<<_x, y, rest::binary>>), do: count_pair(<<y, rest::binary>>)

  defp increment_password(<<x, rest::binary>>) when x == ?z,
    do: <<?a>> <> increment_password(rest)

  defp increment_password(<<x, rest::binary>>), do: <<x + 1, rest::binary>>

  def solution1(input) do
    Stream.iterate(input |> String.reverse(), &increment_password(&1))
    |> Stream.filter(&is_valid_password(&1))
    |> Enum.at(0)
    |> String.reverse()
  end

  def solution2(input) do
    Stream.iterate(input |> String.reverse(), &increment_password(&1))
    |> Stream.filter(&is_valid_password(&1))
    |> Enum.at(1)
    |> String.reverse()
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
