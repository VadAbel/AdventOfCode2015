defmodule Aoc2015Test.Day18Test do
  @day 18

  use ExUnit.Case
  import Aoc2015.Day18

  test "Exemple Day#{@day} - Part 1" do
    assert parse(".#.#.#\n...##.\n#....#\n..#...\n#.#..#\n####..")
           |> next_sign(4)
           |> count_on() == 4
  end

  test "Exemple Day#{@day} - Part 2" do
    assert parse(".#.#.#\n...##.\n#....#\n..#...\n#.#..#\n####..")
           |> set_corner
           |> next_sign2(5)
           |> count_on() == 17
  end
end
