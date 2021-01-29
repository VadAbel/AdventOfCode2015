defmodule Aoc2015Test.Day02Test do
  use ExUnit.Case

  test "Exemple Day02 - Part 1" do
    assert Aoc2015.Day02.paquet([2, 3, 4]) == 58
  end

  test "Exemple Day02 - Part 2" do
    assert Aoc2015.Day02.ribbon([2, 3, 4]) == 34
  end
end
