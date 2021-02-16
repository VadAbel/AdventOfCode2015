defmodule Aoc2015.Day15 do
  @day 15
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  import NimbleParsec

  @recipe_size 100
  @properties_scores [:capacity, :durability, :flavor, :texture]
  @propertie_calories [:calories]

  num =
    ascii_string([?-, ?0..?9], min: 1, max: 2)
    |> map({String, :to_integer, []})

  stat =
    choice([
      string("capacity"),
      string("durability"),
      string("flavor"),
      string("texture"),
      string("calories")
    ])
    |> map({String, :to_existing_atom, []})
    |> ignore(string(" "))
    |> concat(num)
    |> wrap()
    |> map({List, :to_tuple, []})
    |> optional(ignore(string(", ")))

  ingredient =
    ascii_string([?a..?z, ?A..?Z], min: 1)
    |> ignore(string(": "))
    |> concat(
      repeat(stat)
      |> wrap()
      |> map({Map, :new, []})
    )

  defparsec(:ingredient, ingredient)

  def parse_ingredients(input) do
    Stream.map(input, fn x ->
      {:ok, result, _, _, _, _} = ingredient(x)

      result
      |> List.to_tuple()
    end)
    |> Map.new()
  end

  def recipes_list(rest, [ingredient]), do: [[{ingredient, rest}]]

  def recipes_list(rest, [ingredient | rest_ingredient]),
    do: for(x <- 0..rest, y <- recipes_list(rest - x, rest_ingredient), do: [{ingredient, x} | y])

  defp calc_properties(properties, recipe, ingredients_list) do
    properties
    |> Enum.reduce(
      1,
      fn propertie, acc ->
        (recipe
         |> Enum.map(fn {ingredient, qty} -> ingredients_list[ingredient][propertie] * qty end)
         |> Enum.sum()
         |> max(0)) * acc
      end
    )
  end

  def recipe_score_calories(recipe, ingredients_list) do
    %{
      :score => calc_properties(@properties_scores, recipe, ingredients_list),
      :calories => calc_properties(@propertie_calories, recipe, ingredients_list)
    }
  end

  def solution1(input) do
    list_ingredients = parse_ingredients(input)

    recipes_list(@recipe_size, Map.keys(list_ingredients))
    |> Enum.map(&recipe_score_calories(&1, list_ingredients))
    |> Enum.max_by(& &1[:score])
    |> Map.get(:score)
  end

  def solution2(input) do
    list_ingredients = parse_ingredients(input)

    recipes_list(@recipe_size, Map.keys(list_ingredients))
    |> Enum.map(&recipe_score_calories(&1, list_ingredients))
    |> Enum.filter(&(&1[:calories] == 500))
    |> Enum.max_by(& &1[:score])
    |> Map.get(:score)
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
