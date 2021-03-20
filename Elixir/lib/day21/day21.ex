defmodule Aoc2015.Day21 do
  @day "21"
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  @player_life 100
  @empty_stat %{cost: 0, damage: 0, armor: 0}
  @weapons_list [
    %{name: "Dagger", cost: 8, damage: 4, armor: 0},
    %{name: "Shortsword", cost: 10, damage: 5, armor: 0},
    %{name: "Warhammer", cost: 25, damage: 6, armor: 0},
    %{name: "Longsword", cost: 40, damage: 7, armor: 0},
    %{name: "Greataxe", cost: 74, damage: 8, armor: 0}
  ]
  @armors_list [
    %{name: "Leather", cost: 13, damage: 0, armor: 1},
    %{name: "Chainmail", cost: 31, damage: 0, armor: 2},
    %{name: "Splintmail", cost: 53, damage: 0, armor: 3},
    %{name: "Bandedmail", cost: 75, damage: 0, armor: 4},
    %{name: "Platemail", cost: 102, damage: 0, armor: 5}
  ]
  @rings_list [
    %{name: "Damage +1", cost: 25, damage: 1, armor: 0},
    %{name: "Damage +2", cost: 50, damage: 2, armor: 0},
    %{name: "Damage +3", cost: 100, damage: 3, armor: 0},
    %{name: "Defense +1", cost: 20, damage: 0, armor: 1},
    %{name: "Defense +2", cost: 40, damage: 0, armor: 2},
    %{name: "Defense +3", cost: 80, damage: 0, armor: 3}
  ]
  @equipements [
    {1, 1, @weapons_list},
    {0, 1, @armors_list},
    {0, 2, @rings_list}
  ]

  def create_players([]), do: [@empty_stat]

  def create_players([{min_item, max_item, list_item} | tail]) do
    for item_to_peek <- min_item..max_item,
        items_peek <- take_n_from(item_to_peek, list_item),
        next_item <- create_players(tail),
        do: add_stats(items_peek, next_item)
  end

  def take_n_from(0, _list), do: [@empty_stat]

  def take_n_from(count, list) do
    for x <- list, y <- take_n_from(count - 1, list -- [x]), do: add_stats(x, y)
  end

  def add_stats(x, y) do
    %{
      cost: x.cost + y.cost,
      damage: x.damage + y.damage,
      armor: x.armor + y.armor
    }
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn
      "Hit Points: " <> x -> {:life, String.to_integer(x)}
      "Damage: " <> x -> {:damage, String.to_integer(x)}
      "Armor: " <> x -> {:armor, String.to_integer(x)}
    end)
    |> Map.new()
  end

  def turn_to_kill_by(defender, attacker),
    do: ceil(defender.life / max(attacker.damage - defender.armor, 1))

  def solution1(input) do
    boss = input |> parse()

    create_players(@equipements)
    |> Enum.map(&Map.put(&1, :life, @player_life))
    |> Enum.sort(&(&1.cost < &2.cost))
    |> Enum.find(@empty_stat, fn player ->
      turn_to_kill_by(player, boss) >= turn_to_kill_by(boss, player)
    end)
    |> (& &1.cost).()
  end

  def solution2(input) do
    boss = input |> parse()

    create_players(@equipements)
    |> Enum.map(&Map.put(&1, :life, @player_life))
    |> Enum.sort(&(&1.cost > &2.cost))
    |> Enum.find(@empty_stat, fn player ->
      turn_to_kill_by(player, boss) < turn_to_kill_by(boss, player)
    end)
    |> (& &1.cost).()
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
