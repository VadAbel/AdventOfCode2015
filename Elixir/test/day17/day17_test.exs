defmodule Aoc2015Test.Day17Test do
  @day 17

  use ExUnit.Case

  test "Exemple Day#{@day} - Part 1" do
    assert Aoc2015.Day17.combinaison([20, 15, 10, 5, 5], 25) |> Enum.count() == 4
    # assert Aoc2015.Day17.combinaison([5, 5, 10, 15, 20], 25)  == 4
  end

  test "Exemple Day#{@day} - Part 2" do
  end
end
