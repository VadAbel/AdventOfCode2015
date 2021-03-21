defmodule Aoc2015.Day13 do
  @day "13"
  @input_file "../inputs/day#{@day}.txt"

  import NimbleParsec

  letters = [?a..?z, ?A..?Z]

  action =
    choice([
      string("gain") |> replace(:plus),
      string("lose") |> replace(:moins)
    ])

  happiness =
    ascii_string(letters, min: 1)
    |> ignore(string(" would "))
    |> concat(action)
    |> ignore(string(" "))
    |> integer(min: 1, max: 3)
    |> ignore(string(" happiness units by sitting next to "))
    |> ascii_string(letters, min: 1)
    |> ignore(string("."))

  defparsec(:happiness, happiness)

  def parse_happiness(input) do
    Stream.map(input, fn x ->
      {:ok, result, _, _, _, _} = happiness(x)
      result
    end)
    |> Enum.reduce(%{}, fn [neighbor1, action, value, neighbor2], acc ->
      put_in(
        acc,
        [Access.key(neighbor1, %{}), Access.key(neighbor2, {:plus, 0})],
        {action, value}
      )
    end)
  end

  defp permutation([]), do: [[]]

  defp permutation(list),
    do: for(elem <- list, rest <- permutation(list -- [elem]), do: [elem | rest])

  def return_happiness({:plus, happiness}), do: happiness
  def return_happiness({:moins, happiness}), do: -happiness

  def calc_neighbor(["me", _neigh2], _map_happiness), do: 0
  def calc_neighbor([_neigh1, "me"], _map_happiness), do: 0

  def calc_neighbor([neigh1, neigh2], map_happiness),
    do:
      return_happiness(map_happiness[neigh1][neigh2]) +
        return_happiness(map_happiness[neigh2][neigh1])

  def calc_table(table, map_happiness) do
    (table ++ [hd(table)])
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&calc_neighbor(&1, map_happiness))
    |> Enum.sum()
  end

  def calc_happiness(map_happiness) do
    Map.keys(map_happiness)
    |> permutation()
    |> Enum.map(&calc_table(&1, map_happiness))
    |> Enum.max()
  end

  def calc_happiness2(map_happiness) do
    (Map.keys(map_happiness) ++ ["me"])
    |> permutation()
    |> Enum.map(&calc_table(&1, map_happiness))
    |> Enum.max()
  end

  def solution1(input) do
    input
    |> parse_happiness()
    |> calc_happiness()
  end

  def solution2(input) do
    input
    |> parse_happiness()
    |> calc_happiness2()
  end

  def part1 do
    File.stream!(@input_file)
    |> solution1
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part2 do
    File.stream!(@input_file)
    |> solution2
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end
end
