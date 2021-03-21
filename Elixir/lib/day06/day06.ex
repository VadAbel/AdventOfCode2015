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
    instructions = parse_instructions(input)

    for x <- 0..999,
        instructions_x =
          Enum.filter(instructions, fn [_order, {x_start, _y_start}, {x_end, _y_end}] ->
            x >= x_start and x <= x_end
          end),
        y <- 0..999,
        instructions_y =
          Enum.filter(instructions_x, fn [_order, {_x_start, y_start}, {_x_end, y_end}] ->
            y >= y_start and y <= y_end
          end),
        reduce: 0 do
      acc ->
        Enum.reduce(instructions_y, 0, fn [order, _, _], acc_point ->
          case order do
            :turn_on -> 1
            :turn_off -> 0
            :toggle -> if acc_point == 1, do: 0, else: 1
          end
        end)
        |> (&(&1 + acc)).()
    end
  end

  def solution1_5(input) do
    instructions = parse_instructions(input)

    0..999
    |> Enum.reduce(
      0,
      fn x, acc_x ->
        instructions_x =
          Enum.filter(instructions, fn [_order, {x_start, _y_start}, {x_end, _y_end}] ->
            x >= x_start and x <= x_end
          end)

        0..999
        |> Enum.reduce(0, fn y, acc_y ->
          instructions_y =
            Enum.filter(instructions_x, fn [_order, {_x_start, y_start}, {_x_end, y_end}] ->
              y >= y_start and y <= y_end
            end)

          Enum.reduce(instructions_y, 0, fn [order, _, _], acc_point ->
            case order do
              :turn_on -> 1
              :turn_off -> 0
              :toggle -> if acc_point == 1, do: 0, else: 1
            end
          end)
          |> (&(&1 + acc_y)).()
        end)
        |> (&(&1 + acc_x)).()
      end
    )
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

  def solution2_3(input) do
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
              :turn_on ->
                update_in(carte, [Access.key(x, %{}), Access.key(y, 0)], &(&1 + 1))

              :turn_off ->
                update_in(
                  carte,
                  [Access.key(x, %{}), Access.key(y, 0)],
                  &if(&1 == 0, do: 0, else: &1 - 1)
                )

              :toggle ->
                update_in(carte, [Access.key(x, %{}), Access.key(y, 0)], &(&1 + 2))
            end
        end
      end
    )
    |> Enum.reduce(0, fn {_, line}, acc ->
      Enum.reduce(line, 0, fn {_, state}, acc_line -> state + acc_line end) + acc
    end)
  end

  def solution2_4(input) do
    instructions = parse_instructions(input)

    for x <- 0..999,
        instructions_x =
          Enum.filter(instructions, fn [_order, {x_start, _y_start}, {x_end, _y_end}] ->
            x >= x_start and x <= x_end
          end),
        y <- 0..999,
        instructions_y =
          Enum.filter(instructions_x, fn [_order, {_x_start, y_start}, {_x_end, y_end}] ->
            y >= y_start and y <= y_end
          end) do
      Enum.reduce(instructions_y, 0, fn [order, _, _], acc_point ->
        case order do
          :turn_on -> acc_point + 1
          :turn_off -> max(acc_point - 1, 0)
          :toggle -> acc_point + 2
        end
      end)
    end
    |> Enum.sum()
  end

  def solution2_5(input) do
    instructions = parse_instructions(input)

    0..999
    |> Enum.reduce(
      0,
      fn x, acc_x ->
        instructions_x =
          Enum.filter(instructions, fn [_order, {x_start, _y_start}, {x_end, _y_end}] ->
            x >= x_start and x <= x_end
          end)

        0..999
        |> Enum.reduce(0, fn y, acc_y ->
          instructions_y =
            Enum.filter(instructions_x, fn [_order, {_x_start, y_start}, {_x_end, y_end}] ->
              y >= y_start and y <= y_end
            end)

          Enum.reduce(instructions_y, 0, fn [order, _, _], acc_point ->
            case order do
              :turn_on -> acc_point + 1
              :turn_off -> max(acc_point - 1, 0)
              :toggle -> acc_point + 2
            end
          end)
          |> (&(&1 + acc_y)).()
        end)
        |> (&(&1 + acc_x)).()
      end
    )
  end

  def part1_1 do
    File.stream!(@input_file)
    |> solution1
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part1_2 do
    File.stream!(@input_file)
    |> solution1_2
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part1_3 do
    File.stream!(@input_file)
    |> solution1_3
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part1_4 do
    File.stream!(@input_file)
    |> solution1_4
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part1_5 do
    File.stream!(@input_file)
    |> solution1_5
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part1 do
    Benchee.run(%{
      "Part1_1" => fn -> part1_1() end,
      "Part1_2" => fn -> part1_2() end,
      "Part1_3" => fn -> part1_3() end,
      "Part1_4" => fn -> part1_4() end,
      "Part1_5" => fn -> part1_5() end
    })
  end

  def part2_1 do
    File.stream!(@input_file)
    |> solution2_1
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end

  def part2_2 do
    File.stream!(@input_file)
    |> solution2_2
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end

  def part2_3 do
    File.stream!(@input_file)
    |> solution2_3
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end

  def part2_4 do
    File.stream!(@input_file)
    |> solution2_4
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end

  def part2_5 do
    File.stream!(@input_file)
    |> solution2_5
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end

  def part2 do
    Benchee.run(%{
      "Part2_1" => fn -> part2_1() end,
      "Part2_2" => fn -> part2_2() end,
      "Part2_3" => fn -> part2_3() end,
      "Part2_4" => fn -> part2_4() end,
      "Part2_5" => fn -> part2_5() end
    })
  end
end
