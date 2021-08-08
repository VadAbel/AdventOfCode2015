defmodule Aoc2015.Day06 do
  @day "06"
  @input_file "../inputs/day#{@day}.txt"

  import NimbleParsec

  order =
    choice([
      string("turn on") |> replace(:turn_on),
      string("turn off") |> replace(:turn_off),
      string("toggle") |> replace(:toggle)
    ])

  point =
    integer(min: 1, max: 4)
    |> ignore(string(","))
    |> integer(min: 1, max: 4)
    |> wrap()
    |> map({List, :to_tuple, []})

  instruction =
    order
    |> ignore(string(" "))
    |> concat(point)
    |> ignore(string(" through "))
    |> concat(point)

  defparsec(:instruction, instruction)

  defp parse_instructions(input) do
    Stream.map(input, fn x ->
      {:ok, result, _, _, _, _} = instruction(x)
      result
    end)
  end

  def solution1_6(input) do
    instructions = parse_instructions(input)

    0..999
    |> Task.async_stream(fn x ->
      instructions_x =
        instructions
        |> Enum.filter(fn [_order, {x_start, _y_start}, {x_end, _y_end}] ->
          x >= x_start and x <= x_end
        end)

      Enum.map(0..999, fn y ->
        instructions_x
        |> Enum.filter(fn [_order, {_x_start, y_start}, {_x_end, y_end}] ->
          y >= y_start and y <= y_end
        end)
        |> Enum.reduce(0, fn [order, _, _], acc ->
          case order do
            :turn_on -> 1
            :turn_off -> 0
            :toggle -> if acc == 1, do: 0, else: 1
          end
        end)
      end)
    end)
    |> Stream.flat_map(fn {:ok, x} -> x end)
    |> Enum.sum()
  end

  def solution2_6(input) do
    instructions = parse_instructions(input)

    0..999
    |> Task.async_stream(fn x ->
      instructions_x =
        instructions
        |> Enum.filter(fn [_order, {x_start, _y_start}, {x_end, _y_end}] ->
          x >= x_start and x <= x_end
        end)

      Enum.map(0..999, fn y ->
        instructions_x
        |> Enum.filter(fn [_order, {_x_start, y_start}, {_x_end, y_end}] ->
          y >= y_start and y <= y_end
        end)
        |> Enum.reduce(0, fn [order, _, _], acc ->
          case order do
            :turn_on -> acc + 1
            :turn_off -> max(acc - 1, 0)
            :toggle -> acc + 2
          end
        end)
      end)
    end)
    |> Stream.flat_map(fn {:ok, x} -> x end)
    |> Enum.sum()
  end

  def part1_6 do
    File.stream!(@input_file)
    |> solution1_6
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part1 do
    Benchee.run(%{
      "Part1_6" => fn -> part1_6() end
    })
  end

  def part2_6 do
    File.stream!(@input_file)
    |> solution2_6
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end

  def part2 do
    Benchee.run(%{
      "Part2_6" => fn -> part2_6() end
    })
  end
end
