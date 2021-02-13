defmodule Aoc2015.Day11 do
  def is_valid_password(password),
    do: include_straight(password) && has_valid_char(password) && has_two_pair(password)

  def include_straight(password) when byte_size(password) < 3, do: false
  def include_straight(<<x, y, z, _rest::binary>>) when z == y + 1 and y == x + 1, do: true
  def include_straight(<<_x, y, z, rest::binary>>), do: include_straight(<<y, z, rest::binary>>)

  def has_valid_char(password),
    do: not String.contains?(password, :binary.compile_pattern(["i", "o", "l"]))

  def has_two_pair(password), do: count_pair(password) >= 2

  defp count_pair(password) when byte_size(password) < 2, do: 0
  defp count_pair(<<x, y, rest::binary>>) when x == y, do: 1 + count_pair(rest)
  defp count_pair(<<_x, y, rest::binary>>), do: count_pair(<<y, rest::binary>>)

  def next_valid_password(password) do
    next_password = increment_password(password)

    case is_valid_password(next_password) do
      true -> next_password
      _ -> next_valid_password(next_password)
    end
  end

  defp increment_password(password) do
    password
    |> String.reverse()
    |> increment_reverse_password()
    |> String.reverse()
  end

  defp increment_reverse_password(<<x, rest::binary>>) when x == ?z,
    do: <<?a>> <> increment_reverse_password(rest)

  defp increment_reverse_password(<<x, rest::binary>>), do: <<x + 1, rest::binary>>

  def solution1(input) do
    input
    |> next_valid_password()
  end

  def solution2(input) do
    input
    |> next_valid_password()
    |> next_valid_password()
  end

  def part1 do
    File.read!("./lib/day11/day11.txt")
    |> solution1
    |> IO.inspect(label: "Day11 Part 1 result ")
  end

  def part2 do
    File.read!("./lib/day11/day11.txt")
    |> solution2
    |> IO.inspect(label: "Day11 Part 2 result ")
  end
end