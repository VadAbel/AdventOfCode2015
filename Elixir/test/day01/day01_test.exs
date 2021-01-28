defmodule Aoc2015Test.Day01Test do
  use ExUnit.Case

  test "Exemple Day01 - Part 1" do
    assert Aoc2015.Day01.solution1("(())") == 0
    assert Aoc2015.Day01.solution1("()()") == 0

    assert Aoc2015.Day01.solution1("(((") == 3
    assert Aoc2015.Day01.solution1("(()(()(") == 3

    assert Aoc2015.Day01.solution1("))(((((") == 3

    assert Aoc2015.Day01.solution1("())") == -1
    assert Aoc2015.Day01.solution1("))(") == -1

    assert Aoc2015.Day01.solution1(")))") == -3
    assert Aoc2015.Day01.solution1(")())())") == -3
  end

  test "Exemple Day01 - Part 2" do
    assert Aoc2015.Day01.solution2(")") == 1
    assert Aoc2015.Day01.solution2("()())") == 5
  end
end
