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
      :turn_on -> Map.put(carte, point, true)
      :turn_off -> Map.put(carte, point, false)
      :toggle -> Map.update(carte, point, true, &(not &1))
    end
  end

  defp dim(carte, point, order) do
    case order do
      :turn_on ->
        Map.update(carte, point, 1, &(&1 + 1))

      :turn_off ->
        Map.update(carte, point, 0, fn x ->
          case x do
            0 -> 0
            _ -> x - 1
          end
        end)

      :toggle ->
        Map.update(carte, point, 2, &(&1 + 2))
    end
  end

  defp parse_instructions(input) do
    Stream.map(input, fn x ->
      {:ok, result, _, _, _, _} = instruction(x)
      result
    end)
  end

  def solution1(input) do
    input
    |> parse_instructions()
    |> Enum.reduce(%{}, fn [order, {x_start, y_start}, {x_end, y_end}], light_map ->
      for x <- x_start..x_end,
          y <- y_start..y_end,
          reduce: light_map do
        acc -> switch(acc, {x, y}, order)
      end
    end)
    |> Enum.count(fn {_, state} -> state end)
  end

  def solution1_2(input) do
    input
    |> parse_instructions()
    |> Enum.reduce(%{}, fn [order, {x_start, y_start}, {x_end, y_end}], light_map ->
      for x <- x_start..x_end,
          y <- y_start..y_end,
          reduce: light_map do
        acc -> Map.update(acc, x, switch(%{}, y, order), fn line -> switch(line, y, order) end)
      end
    end)
    |> Enum.reduce(0, fn {_, line}, acc ->
      Enum.count(line, fn {_, state} -> state end) + acc
    end)
  end

  def solution1_3(input) do
    input
    |> parse_instructions()
    |> Enum.reduce(
      %{},
      fn [order, {x_start, y_start}, {x_end, y_end}], carte ->
        for x <- x_start..x_end,
            y <- y_start..y_end,
            reduce: carte do
          carte ->
            case order do
              :turn_on -> put_in(carte, [Access.key(x, %{}), Access.key(y, false)], true)
              :turn_off -> put_in(carte, [Access.key(x, %{}), Access.key(y, false)], false)
              :toggle -> update_in(carte, [Access.key(x, %{}), Access.key(y, false)], &(not &1))
            end
        end
      end
    )
    |> Enum.reduce(0, fn {_, line}, acc ->
      Enum.count(line, fn {_, state} -> state end) + acc
    end)
  end

  def solution1_4(input) do
    light_map =
      for x <- 0..999 do
        %{
          :x => x,
          :line =>
            for y <- 0..999 do
              %{
                :y => y,
                :state => false
              }
            end
        }
      end

    input
    |> parse_instructions()
    |> Enum.reduce(light_map, fn [order, {x_start, y_start}, {x_end, y_end}], carte ->
      range = [
        Access.filter(&(&1.x in x_start..x_end)),
        :line,
        Access.filter(&(&1.y in y_start..y_end)),
        :state
      ]

      case order do
        :turn_on -> put_in(carte, range, true)
        :turn_off -> put_in(carte, range, false)
        :toggle -> update_in(carte, range, &(not &1))
      end
    end)
    |> get_in([Access.all(), :line, Access.all(), :state])
    |> Enum.reduce(0, fn x, acc -> Enum.count(x, & &1) + acc end)
  end

  def solution2_1(input) do
    input
    |> parse_instructions()
    |> Enum.reduce(%{}, fn [order, {x_start, y_start}, {x_end, y_end}], carte ->
      for x <- x_start..x_end,
          y <- y_start..y_end,
          reduce: carte do
        carte -> dim(carte, {x, y}, order)
      end
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def solution2_2(input) do
    input
    |> parse_instructions()
    |> Enum.reduce(%{}, fn [order, {x_start, y_start}, {x_end, y_end}], light_map ->
      for x <- x_start..x_end,
          y <- y_start..y_end,
          reduce: light_map do
        acc -> Map.update(acc, x, dim(%{}, y, order), fn line -> dim(line, y, order) end)
      end
    end)
    |> Enum.reduce(0, fn {_, line}, acc ->
      Enum.reduce(line, 0, fn {_, state}, acc_line -> state + acc_line end) + acc
    end)
  end

  def part1_1 do
    File.stream!("./lib/day06/day06.txt")
    |> solution1
    |> IO.inspect(label: "Day06 Part 1 result : ")
  end

  def part1_2 do
    File.stream!("./lib/day06/day06.txt")
    |> solution1_2
    |> IO.inspect(label: "Day06 Part 1 result : ")
  end

  def part1_3 do
    File.stream!("./lib/day06/day06.txt")
    |> solution1_3
    |> IO.inspect(label: "Day06 Part 1 result : ")
  end

  def part1_4 do
    File.stream!("./lib/day06/day06.txt")
    |> solution1_4
    |> IO.inspect(label: "Day06 Part 1 result : ")
  end

  def part1 do
    Benchee.run(%{
      "Part1_1" => fn -> part1_1() end,
      "Part1_2" => fn -> part1_2() end,
      "Part1_3" => fn -> part1_3() end,
      "Part1_4" => fn -> part1_4() end
    })
  end

  def part2_1 do
    File.stream!("./lib/day06/day06.txt")
    |> solution2_1
    |> IO.inspect(label: "Day06 Part 2 result : ")
  end

  def part2_2 do
    File.stream!("./lib/day06/day06.txt")
    |> solution2_2
    |> IO.inspect(label: "Day06 Part 2 result : ")
  end

  def part2 do
    Benchee.run(%{
      "Part2_1" => fn -> part2_1() end,
      "Part2_2" => fn -> part2_2() end
    })
  end
end
