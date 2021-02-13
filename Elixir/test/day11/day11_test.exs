defmodule Aoc2015Test.Day11Test do
  use ExUnit.Case

  test "Exemple Day11 - Part 1" do
    assert Aoc2015.Day11.include_straight("hijklmmn") == true
    assert Aoc2015.Day11.has_valid_char("hijklmn") == false
    assert Aoc2015.Day11.has_two_pair("abbceffg") == true
    assert Aoc2015.Day11.has_two_pair("abbcegjk") == false
    assert Aoc2015.Day11.next_valid_password("abcdefgh") == "abcdffaa"
    #assert Aoc2015.Day11.next_valid_password("ghijklmn") == "ghjaabcc"
  end

  test "Exemple Day11 - Part 2" do
  end
end
