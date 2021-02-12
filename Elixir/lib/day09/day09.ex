defmodule Aoc2015.Day09 do
  import NimbleParsec

  distance =
    ascii_string([?a..?z, ?A..?Z], min: 1)
    |> ignore(string(" to "))
    |> concat(ascii_string([?a..?z, ?A..?Z], min: 1))
    |> ignore(string(" = "))
    |> integer(min: 1)

  defparsec(:distance, distance)

  defp parse_distances(input) do
    input
    |> Stream.map(fn x ->
      {:ok, result, _, _, _, _} = distance(x)
      result
    end)
    |> Enum.reduce(%{}, fn [town1, town2, distance], distances ->
      Map.put(distances, Enum.sort([town1, town2]), distance)
    end)
  end

  def get_towns_list(distances) do
    Map.keys(distances)
    |> Enum.concat()
    |> Enum.uniq()
  end

  defp permutation([]), do: [[]]

  defp permutation(list),
    do: for(elem <- list, rest <- permutation(list -- [elem]), do: [elem | rest])

  defp calc_distance([_ | []], _), do: 0

  defp calc_distance([town1 | [town2 | tail]], distances) do
    Map.get(distances, Enum.sort([town1, town2])) + calc_distance([town2 | tail], distances)
  end

  defp calc_routes(distances) do
    get_towns_list(distances)
    |> permutation()
    |> Enum.map(&calc_distance(&1, distances))
  end

  def solution1(input) do
    input
    |> Stream.map(&String.trim/1)
    |> parse_distances
    |> calc_routes
    |> Enum.min()
  end

  def solution2(input) do
    input
    |> Stream.map(&String.trim/1)
    |> parse_distances
    |> calc_routes
    |> Enum.max()
  end

  def part1 do
    File.stream!("./lib/day09/day09.txt")
    |> solution1
    |> IO.inspect(label: "Day09 Part 1 result ")
  end

  def part2 do
    File.stream!("./lib/day09/day09.txt")
    |> solution2
    |> IO.inspect(label: "Day09 Part 2 result ")
  end
end
