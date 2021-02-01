defmodule Aoc2015.Day06 do
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

  defp switch(carte, point, order) do
    case order do
      :turn_on -> Map.update(carte, point, true, fn _ -> true end)
      :turn_off -> Map.update(carte, point, false, fn _ -> false end)
      :toggle -> Map.update(carte, point, true, fn x -> not x end)
    end
  end

  defp dim(carte, point, order) do
    case order do
      :turn_on ->
        Map.update(carte, point, 1, fn x -> x + 1 end)

      :turn_off ->
        Map.update(carte, point, 0, fn x ->
          case x do
            0 -> 0
            _ -> x - 1
          end
        end)

      :toggle ->
        Map.update(carte, point, 2, fn x -> x + 2 end)
    end
  end

  def solution1(input) do
    input
    |> Stream.map(fn x ->
      {:ok, result, _, _, _, _} = instruction(x)
      result
    end)
    |> Enum.reduce(%{}, fn [order, start_point, end_point], carte ->
      {x_start, y_start} = start_point
      {x_end, y_end} = end_point

      for(
        x <- x_start..x_end,
        y <- y_start..y_end,
        do: {x, y}
      )
      |> Enum.reduce(carte, &switch(&2, &1, order))
    end)
    |> Map.values()
    |> Enum.count(&(&1 == true))
  end

  def solution2(input) do
    input
    |> Stream.map(fn x ->
      {:ok, result, _, _, _, _} = instruction(x)
      result
    end)
    |> Enum.reduce(%{}, fn [order, start_point, end_point], carte ->
      {x_start, y_start} = start_point
      {x_end, y_end} = end_point

      for(
        x <- x_start..x_end,
        y <- y_start..y_end,
        do: {x, y}
      )
      |> Enum.reduce(carte, &dim(&2, &1, order))
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def part1 do
    File.stream!("./lib/day06/day06.txt")
    |> solution1
    |> IO.inspect(label: "Day06 Part 1 result : ")
  end

  def part2 do
    File.stream!("./lib/day06/day06.txt")
    |> solution2
    |> IO.inspect(label: "Day06 Part 2 result : ")
  end
end
