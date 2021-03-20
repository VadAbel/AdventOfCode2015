defmodule Aoc2015.Day23 do
  @day "23"
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  require Integer

  defp parse_instruction(line) do
    inst = String.split(line, [" ", ", "])

    case inst do
      [ope, register] when ope in ["hlf", "tpl", "inc"] ->
        {String.to_atom(ope), String.to_atom(register)}

      ["jmp", offset] ->
        {:jmp, String.to_integer(offset)}

      [ope, register, offset] when ope in ["jie", "jio"] ->
        {String.to_atom(ope), String.to_atom(register), String.to_integer(offset)}
    end
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction(&1))
  end

  def process_instruction({:hlf, reg}, registers),
    do:
      process_instruction(
        {:jmp, 1},
        Map.update!(registers, reg, &ceil(&1 / 2))
      )

  def process_instruction({:tpl, reg}, registers),
    do:
      process_instruction(
        {:jmp, 1},
        Map.update!(registers, reg, &(&1 * 3))
      )

  def process_instruction({:inc, reg}, registers),
    do:
      process_instruction(
        {:jmp, 1},
        Map.update!(registers, reg, &(&1 + 1))
      )

  def process_instruction({:jmp, offset}, registers),
    do: Map.update!(registers, :ip, &(&1 + offset))

  def process_instruction({:jie, reg, offset}, registers) do
    offset =
      if Integer.is_even(Map.get(registers, reg)),
        do: offset,
        else: 1

    process_instruction({:jmp, offset}, registers)
  end

  def process_instruction({:jio, reg, offset}, registers) do
    offset =
      if Map.get(registers, reg) == 1,
        do: offset,
        else: 1

    process_instruction({:jmp, offset}, registers)
  end

  def process(registers = %{ip: ip}, instructions) when ip >= length(instructions),
    do: registers.b

  def process(registers = %{ip: ip}, instructions) do
    Enum.at(instructions, ip)
    |> process_instruction(registers)
    |> process(instructions)
  end

  def solution1(input) do
    instructions = parse(input)
    registers = %{a: 0, b: 0, ip: 0}

    process(registers, instructions)
  end

  def solution2(input) do
    instructions = parse(input)
    registers = %{a: 1, b: 0, ip: 0}

    process(registers, instructions)
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
