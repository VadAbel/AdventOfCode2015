defmodule Aoc2015.Day18 do
  @day 18
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  @loop 100

  def set_corner(sign) do
    process_line = fn [line] -> [[:on] ++ Enum.slice(line, 1..-2) ++ [:on]] end

    process_line.(Enum.take(sign, 1)) ++
      Enum.slice(sign, 1..-2) ++
      process_line.(Enum.take(sign, -1))
  end

  def next_sign(sign, 0), do: sign

  def next_sign(sign, rest) do
    for y <- 0..(length(sign) - 1) do
      for x <- 0..(length(Enum.at(sign, y)) - 1) do
        next_pos_state(sign, {x, y})
      end
    end
    |> next_sign(rest - 1)
  end

  def next_sign2(sign, 0), do: sign

  def next_sign2(sign, rest) do
    for y <- 0..(length(sign) - 1) do
      for x <- 0..(length(Enum.at(sign, y)) - 1) do
        next_pos_state(sign, {x, y})
      end
    end
    |> set_corner()
    |> next_sign2(rest - 1)
  end

  def next_pos_state(sign, {x, y}) do
    state = Enum.at(sign, y) |> Enum.at(x)

    take_neigh = fn list, pos ->
      Enum.slice(list, max(pos - 1, 0)..min(pos + 1, length(list) - 1))
    end

    neigh_on =
      sign
      |> take_neigh.(y)
      |> Enum.map(&take_neigh.(&1, x))
      |> count_on()

    case state do
      :on ->
        if (neigh_on - 1) in [2, 3], do: :on, else: :off

      :off ->
        if neigh_on in [3], do: :on, else: :off
    end
  end

  def count_on(sign) do
    sign
    |> Enum.map(&Enum.count(&1, fn x -> x == :on end))
    |> Enum.sum()
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.codepoints()
      |> Enum.map(fn
        "." -> :off
        "#" -> :on
      end)
    end)
  end

  def solution1(input) do
    input
    |> parse
    |> next_sign(@loop)
    |> count_on()
  end

  def solution2(input) do
    input
    |> parse
    |> set_corner()
    |> next_sign2(@loop)
    |> count_on()
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
