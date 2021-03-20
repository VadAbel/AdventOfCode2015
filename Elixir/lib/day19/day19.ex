defmodule Aoc2015.Day19 do
  @day "19"
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  def parse(input) do
    [replacements, molecule] = String.split(input, "\n\n")

    replacements_part1 =
      replacements
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " => "))
      |> Enum.reduce(%{}, fn [x, y], acc -> Map.update(acc, x, [y], &[y | &1]) end)

    replacements_part2 =
      replacements
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " => "))
      |> Enum.reduce(%{}, fn [x, y], acc -> Map.put(acc, y, x) end)

    {molecule, replacements_part1, replacements_part2}
  end

  def find_molecule(molecule, replacements, molecules_list \\ [])

  def find_molecule(
        {_head_mol, "", ""},
        _replacements,
        molecules_list
      ),
      do: molecules_list

  def find_molecule(
        {head_mol, process_mol, tail_mol},
        replacements,
        molecules_list
      ) do
    new_mol_list =
      Map.get(replacements, process_mol, [])
      |> Enum.map(&(head_mol <> &1 <> tail_mol))

    next_atom({head_mol <> process_mol, "", tail_mol})
    |> find_molecule(replacements, molecules_list ++ new_mol_list)
  end

  def next_atom({head_mol, "", <<x, tail_mol::binary>>}) when x in ?A..?Z,
    do: next_atom({head_mol, <<x>>, tail_mol})

  def next_atom({head_mol, process_mol, <<x, tail_mol::binary>>}) when x in ?a..?z,
    do: next_atom({head_mol, process_mol <> <<x>>, tail_mol})

  def next_atom({head_mol, process_mol, tail_mol}),
    do: {head_mol, process_mol, tail_mol}

  def reduce_molecule("e", _replacements, step), do: step
  def reduce_molecule(molecule, replacements, step) do
    Map.keys(replacements)
    |> Enum.sort(&(String.length(&1) > String.length(&2)))
    |> Enum.reduce_while(molecule, fn x, acc ->
      if String.contains?(acc, x) do
        molecule = String.replace(acc, x, replacements[x], global: false)
        {:halt, reduce_molecule(molecule, replacements, step + 1)}
      else
        {:cont, acc}
      end
    end)
  end

  def solution1(input) do
    {molecule, replacements, _} = parse(input)

    next_atom({"", "", molecule})
    |> find_molecule(replacements)
    |> Enum.uniq()
    |> Enum.count()
  end

  def solution2(input) do
    {molecule, _, replacements} = parse(input)

    reduce_molecule(molecule, replacements, 0)
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
