defmodule Aoc2015Test.Day10Test do
  use ExUnit.Case

  test "Exemple Day10 - Part 1" do
    assert Aoc2015.Day10.process([1]) == [1, 1]
    assert Aoc2015.Day10.process([1],2) == [2, 1]
    assert Aoc2015.Day10.process([1],3) == [1, 2, 1, 1]
    assert Aoc2015.Day10.process([1],4) == [1, 1, 1, 2, 2, 1]
    assert Aoc2015.Day10.process([1],5) == [3, 1, 2, 2, 1, 1]
  end

  test "Exemple Day10 - Part 2" do
  end
end
