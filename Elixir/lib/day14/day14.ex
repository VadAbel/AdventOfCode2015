defmodule Aoc2015.Day14 do
  @day "14"
  @input_file "./lib/day#{@day}/day#{@day}.txt"

  import NimbleParsec

  @olympic_time 2503

  letters = [?a..?z, ?A..?Z]

  reindeer =
    ascii_string(letters, min: 1)
    |> ignore(string(" can fly "))
    |> integer(min: 1, max: 2)
    |> ignore(string(" km/s for "))
    |> integer(min: 1, max: 2)
    |> ignore(string(" seconds, but then must rest for "))
    |> integer(min: 1, max: 3)
    |> ignore(string(" seconds."))

  defparsec(:reindeer, reindeer)

  def parse_reindeer(input) do
    Stream.map(input, fn x ->
      {:ok, result, _, _, _, _} = reindeer(x)
      result
    end)
    |> Enum.reduce(%{}, fn [reindeer, speed, delay, rest], acc ->
      Map.put(acc, reindeer, %{speed: speed, delay: delay, rest: rest})
    end)
  end

  def flying(stat_reindeer, time) when time > stat_reindeer.delay,
    do:
      stat_reindeer.speed * stat_reindeer.delay +
        flying(stat_reindeer, time - stat_reindeer.delay - stat_reindeer.rest)

  def flying(stat_reindeer, time) when time > 0, do: stat_reindeer.speed * time
  def flying(_stat_reindeer, _time), do: 0

  def move_reindeer({distance, :flying, delay}, stat_reindeer) when delay == 1,
    do: {distance + stat_reindeer.speed, :rest, stat_reindeer.rest}

  def move_reindeer({distance, :flying, delay}, stat_reindeer),
    do: {distance + stat_reindeer.speed, :flying, delay - 1}

  def move_reindeer({distance, :rest, delay}, stat_reindeer) when delay == 1,
    do: {distance, :flying, stat_reindeer.delay}

  def move_reindeer({distance, :rest, delay}, _stat_reindeer),
    do: {distance, :rest, delay - 1}

  def add_point(list_reindeers) do
    {_, _, {max, _, _}} =
      Enum.max_by(list_reindeers, fn {_reindeer, _point, {distance, _state, _delay}} ->
        distance
      end)

    list_reindeers
    |> Enum.map(fn
      {
        reindeer,
        point,
        {distance, stat, delay}
      } ->
        {
          reindeer,
          case distance do
            ^max -> point + 1
            _ -> point
          end,
          {distance, stat, delay}
        }
    end)
  end

  def turn(list_reindeers, time, _stat_reindeers) when time == 0, do: list_reindeers

  def turn(list_reindeers, time, stat_reindeers) when time > 0 do
    list_reindeers
    |> Enum.map(fn {reindeer, point, x} ->
      {
        reindeer,
        point,
        move_reindeer(x, stat_reindeers[reindeer])
      }
    end)
    |> add_point()
    |> turn(time - 1, stat_reindeers)
  end

  def olympic1(stat_reindeers) do
    Map.keys(stat_reindeers)
    |> Enum.map(fn
      reindeer ->
        flying(stat_reindeers[reindeer], @olympic_time)
    end)
  end

  def olympic2(stat_reindeers) do
    Map.keys(stat_reindeers)
    |> Enum.map(fn reindeer ->
      {
        reindeer,
        0,
        {0, :flying, stat_reindeers[reindeer].delay}
      }
    end)
    |> turn(@olympic_time, stat_reindeers)
  end

  def solution1(input) do
    input
    |> parse_reindeer()
    |> olympic1()
    |> Enum.max()
  end

  def solution2(input) do
    input
    |> parse_reindeer()
    |> olympic2()
    |> Enum.max_by(fn {_reindeer, point, _} -> point end)
    |> elem(1)
  end

  def part1 do
    File.stream!(@input_file)
    |> solution1
    |> IO.inspect(label: "Day#{@day} Part 1 result ")
  end

  def part2 do
    File.stream!(@input_file)
    |> solution2
    |> IO.inspect(label: "Day#{@day} Part 2 result ")
  end
end
