defmodule Aoc2015Test.Day08Test do
  use ExUnit.Case

  test "Exemple Day08 - Part 1" do
    assert String.length(Aoc2015.Day08.decode("abc")) == 3
    assert String.length(Aoc2015.Day08.decode("aaa\\\"aaa")) == 7
    assert String.length(Aoc2015.Day08.decode("\\x27")) == 1
  end

  test "Exemple Day08 - Part 2" do
    assert String.length(Aoc2015.Day08.encode("\"abc\"")) == 7
    assert String.length(Aoc2015.Day08.encode("\"aaa\\\"aaa\"")) == 14
    assert String.length(Aoc2015.Day08.encode("\"\\x27\"")) == 9
  end
end
