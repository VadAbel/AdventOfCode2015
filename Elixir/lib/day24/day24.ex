defmodule Aoc2015.Day24 do
  @day "24"
  @input_file "../inputs/day#{@day}.txt"

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.sort(:desc)
  end

  def add_package(groups, target_weight, packages) do
    Enum.flat_map(
      groups,
      fn x ->
        rest_weight = target_weight - Enum.sum(x)
        possible_packages = Enum.filter(packages, &(&1 < Enum.min(x) && &1 <= rest_weight))
        for package <- possible_packages, do: [package | x]
      end
    )
    |> test_groups(target_weight, packages)
  end

  def test_groups(groups, target_weight, packages) do
    groups_filtred = Enum.filter(groups, &(Enum.sum(&1) == target_weight))

    if groups_filtred == [] do
      add_package(Enum.filter(groups, &(Enum.sum(&1) < target_weight)), target_weight, packages)
    else
      groups_filtred
    end
  end

  def solution1(input) do
    packages = parse(input)
    target_weight = Enum.sum(packages) / 3

    Enum.map(packages, &[&1])
    |> add_package(target_weight, packages)
    |> Enum.map(fn x -> Enum.reduce(x, &(&1 * &2)) end)
    |> Enum.min()
  end

  def solution2(input) do
    packages = parse(input)
    target_weight = Enum.sum(packages) / 4

    Enum.map(packages, &[&1])
    |> add_package(target_weight, packages)
    |> Enum.map(fn x -> Enum.reduce(x, &(&1 * &2)) end)
    |> Enum.min()
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
