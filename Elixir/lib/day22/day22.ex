defmodule Aoc2015.Day22 do
  @day "22"
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  @spells [
    %{name: "Magic Missile", cost: 53, damage: 4, heal: 0, armor: 0, mana: 0, turn: 1},
    %{name: "Drain", cost: 73, damage: 2, heal: 2, armor: 0, mana: 0, turn: 1},
    %{name: "Shield", cost: 113, damage: 0, heal: 0, armor: 7, mana: 0, turn: 6 - 1},
    %{name: "Poison", cost: 173, damage: 3, heal: 0, armor: 0, mana: 0, turn: 6},
    %{name: "Recharge", cost: 229, damage: 0, heal: 0, armor: 0, mana: 101, turn: 5}
  ]

  @player_stat %{
    life: 50,
    mana_pool: 500,
    mana_spend: 0,
    armor: 0
  }

  def lose_1_life(player) do
    Map.update!(player, :life, &(&1 - 1))
  end

  def resolve_spells({player, boss, []}), do: {player, boss, []}

  def resolve_spells({player, boss, [spell | dot]}) do
    boss = Map.update!(boss, :life, &(&1 - spell.damage))
    player = Map.update!(player, :life, &(&1 + spell.heal))
    player = Map.update!(player, :armor, &max(&1, spell.armor))
    player = Map.update!(player, :mana_pool, &(&1 + spell.mana))
    spell = Map.update!(spell, :turn, &(&1 - 1))

    {player, boss, dot} = resolve_spells({player, boss, dot})

    {player, boss, if(spell.turn > 0, do: [spell | dot], else: dot)}
  end

  def possible_spells(dot, mana),
    do:
      Enum.reject(@spells, fn spell ->
        spell.name in Enum.map(dot, fn x -> x.name end) ||
          spell.cost > mana
      end)

  def deduce_mana(player, cost) do
    Map.update!(player, :mana_pool, &(&1 - cost))
    |> Map.update!(:mana_spend, &(&1 + cost))
  end

  def cast_spell({_player = %{life: life}, _boss, _dot}, best, _part2) when life <= 0, do: best

  def cast_spell({player, _boss = %{life: life}, _dot}, best, _part2) when life <= 0 do
    player |> IO.inspect()
    min(player.mana_spend, best)
  end

  def cast_spell({player, boss, dot}, best, part2) do
    for spell <- possible_spells(dot, player.mana_pool),
        player = deduce_mana(player, spell.cost),
        player.mana_spend < best,
        reduce: best do
      acc ->
        resolve_spells({player, boss, [spell | dot]})
        |> boss_attack(acc, part2)
    end
  end

  def boss_attack({player, _boss = %{life: life}, _dot}, best, _part2) when life <= 0 do
    player |> IO.inspect()

    min(player.mana_spend, best)
    |> IO.inspect()
  end

  def boss_attack({player, boss, dot}, best, part2) do
    player = Map.update!(player, :life, &(&1 - max(boss.damage - player.armor, 1)))
    player = Map.put(player, :armor, 0)

    player =
      if part2 do
        lose_1_life(player)
      else
        player
      end

    resolve_spells({player, boss, dot})
    |> cast_spell(best, part2)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn
      "Hit Points: " <> x, acc -> Map.put(acc, :life, String.to_integer(x))
      "Damage: " <> x, acc -> Map.put(acc, :damage, String.to_integer(x))
    end)
  end

  def solution1(input) do
    boss = parse(input)
    player = @player_stat
    dot = []

    cast_spell({player, boss, dot}, nil, false)
  end

  def solution2(input) do
    boss = parse(input)
    player = @player_stat
    dot = []

    cast_spell({lose_1_life(player), boss, dot}, nil, true)
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
