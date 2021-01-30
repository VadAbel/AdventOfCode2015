defmodule Aoc2015.Day05 do
  @reg_vowel ~r/[aeiou]/
  @reg_dual_char ~r/([a-z])\1/
  @forbidden_string ["ab", "cd", "pq", "xy"]

  @reg_dual_char_twice ~r/([a-z][a-z]).*?\1/
  @reg_twice_1between ~r/([a-z])[a-z]\1/

  defp regex_test(chaine, regex, count_min \\ 1),
    do: Regex.scan(regex, chaine) |> Enum.count() >= count_min

  defp vowel_3?(chaine), do: regex_test(chaine, @reg_vowel, 3)
  defp dual_char?(chaine), do: regex_test(chaine, @reg_dual_char)
  defp forbidden_string?(chaine), do: String.contains?(chaine, @forbidden_string)

  defp dual_char_twice?(chaine), do: regex_test(chaine, @reg_dual_char_twice)
  defp twice_1between?(chaine), do: regex_test(chaine, @reg_twice_1between)

  def valid_part1?(chaine),
    do: vowel_3?(chaine) && dual_char?(chaine) && not forbidden_string?(chaine)

  def valid_part2?(chaine),
    do: dual_char_twice?(chaine) && twice_1between?(chaine)

  def solution1(input) do
    input
    |> Enum.count(&valid_part1?/1)
  end

  def solution2(input) do
    input
    |> Enum.count(&valid_part2?/1)
  end

  def part1 do
    File.stream!("./lib/day05/day05.txt")
    |> solution1
    |> IO.inspect(label: "Day05 Part 1 result : ")
  end

  def part2 do
    File.stream!("./lib/day05/day05.txt")
    |> solution2
    |> IO.inspect(label: "Day05 Part 2 result : ")
  end
end
