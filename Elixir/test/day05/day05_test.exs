defmodule Aoc2015Test.Day05Test do
  use ExUnit.Case

  test "Exemple Day05 - Part 1" do
    assert Aoc2015.Day05.valid_part1?("ugknbfddgicrmopn") == true
    assert Aoc2015.Day05.valid_part1?("aaa") == true
    assert Aoc2015.Day05.valid_part1?("jchzalrnumimnmhp") == false
    assert Aoc2015.Day05.valid_part1?("haegwjzuvuyypxyu") == false
    assert Aoc2015.Day05.valid_part1?("dvszwmarrgswjxmb") == false
  end

  test "Exemple Day05 - Part 2" do
    assert Aoc2015.Day05.valid_part2?("qjhvhtzxzqqjkmpb") == true
    assert Aoc2015.Day05.valid_part2?("xxyxx") == true
    assert Aoc2015.Day05.valid_part2?("uurcxstgmygtbstg") == false
    assert Aoc2015.Day05.valid_part2?("ieodomkazucvgmuy") == false
  end
end
