defmodule Aoc2015Test.Day03Test do
  use ExUnit.Case

  test "Exemple Day03 - Part 1" do
    assert Aoc2015.Day03.solution1(">") == 2
    assert Aoc2015.Day03.solution1("^>v<") == 4
    assert Aoc2015.Day03.solution1("^v^v^v^v^v") == 2
  end

  test "Exemple Day03 - Part 2" do
    assert Aoc2015.Day03.solution2("^v") == 3
    assert Aoc2015.Day03.solution2("^>v<") == 3
    assert Aoc2015.Day03.solution2("^v^v^v^v^v") == 11
  end
end
