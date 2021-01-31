defmodule Aoc2015.Day07 do
  import NimbleParsec
  use Bitwise

  wire = ascii_string([?a..?z], min: 1, max: 2)

  input =
    choice([
      wire,
      integer(min: 1, max: 5)
    ])

  door =
    choice([
      string("AND") |> replace(:and),
      string("OR") |> replace(:or),
      string("LSHIFT") |> replace(:lshift),
      string("RSHIFT") |> replace(:rshift),
      string("NOT") |> replace(:not)
    ])

  instruction =
    wrap(
      optional(input |> ignore(string(" ")))
      |> optional(door |> ignore(string(" ")))
      |> optional(input |> ignore(string(" ")))
    )
    |> ignore(string("-> "))
    |> concat(wire)

  defparsec(:instruction, instruction)

  defp resolve_operation(door_list, _wire, [value]) when is_integer(value) do
    {door_list, value}
  end

  defp resolve_operation(door_list, wire, [input]) when is_binary(input) do
    {input_door_list, input_value} = resolve_wire(door_list, input)
    {Map.replace!(input_door_list, wire, [input_value]), input_value}
  end

  defp resolve_operation(door_list, wire, [:not, input]) do
    {input_door_list, input_value} = resolve_wire(door_list, input)
    value = bnot(input_value)
    {Map.replace!(input_door_list, wire, [value]), value}
  end

  defp resolve_operation(door_list, wire, [input1, :and, input2]) do
    {input1_door_list, input1_value} = resolve_wire(door_list, input1)
    {input2_door_list, input2_value} = resolve_wire(input1_door_list, input2)
    value = input1_value &&& input2_value
    {Map.replace!(input2_door_list, wire, [value]), value}
  end

  defp resolve_operation(door_list, wire, [input1, :or, input2]) do
    {input1_door_list, input1_value} = resolve_wire(door_list, input1)
    {input2_door_list, input2_value} = resolve_wire(input1_door_list, input2)
    value = input1_value ||| input2_value
    {Map.replace!(input2_door_list, wire, [value]), value}
  end

  defp resolve_operation(door_list, wire, [input, :lshift, count]) do
    {input_door_list, input_value} = resolve_wire(door_list, input)
    value = input_value <<< count
    {Map.replace!(input_door_list, wire, [value]), value}
  end

  defp resolve_operation(door_list, wire, [input, :rshift, count]) do
    {input_door_list, input_value} = resolve_wire(door_list, input)
    value = input_value >>> count
    {Map.replace!(input_door_list, wire, [value]), value}
  end

  def resolve_wire(door_list, wire) when is_binary(wire) do
    operation = Map.get(door_list, wire)
    resolve_operation(door_list, wire, operation)
  end

  def resolve_wire(door_list, wire) when is_integer(wire) do
    {door_list, wire}
  end

  def solution1(input) do
    {_, result} =
      input
      |> Stream.map(fn x ->
        {:ok, result, _, _, _, _} = instruction(x)
        result
      end)
      |> Enum.reduce(%{}, fn [door, output], acc -> Map.put(acc, output, door) end)
      |> resolve_wire("a")

    result
  end

  def solution2(input) do
    {_, result} =
      input
      |> Stream.map(fn x ->
        {:ok, result, _, _, _, _} = instruction(x)
        result
      end)
      |> Enum.reduce(%{}, fn [door, output], acc -> Map.put(acc, output, door) end)
      |> Map.replace!("b", [part1()])
      |> resolve_wire("a")

    result
  end

  def part1 do
    File.stream!("./lib/day07/day07.txt")
    |> solution1
    |> IO.inspect(label: "Day07 Part 1 result : ")
  end

  def part2 do
    File.stream!("./lib/day07/day07.txt")
    |> solution2
    |> IO.inspect(label: "Day07 Part 2 result : ")
  end
end
