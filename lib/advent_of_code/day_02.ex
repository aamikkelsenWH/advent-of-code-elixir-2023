defmodule AdventOfCode.Day02 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_game/1)
    |> Enum.filter(&valid_game?/1)
    |> Enum.map(&game_ids/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_game/1)
    |> Stream.map(&fewest_number_of_cubes/1)
    |> Stream.map(&Map.values/1)
    |> Enum.map(&Enum.product/1)
    |> Enum.sum()
  end

  defp parse_game(line) do
    [[game_id | [sets]]] =
      Regex.scan(~r/^Game (\d+): (.*)/, line, capture: :all_but_first)

    game_id = String.to_integer(game_id)
    {game_id, parse_sets(sets)}
  end

  defp parse_sets(sets) do
    sets
    |> String.split("; ", trim: true)
    |> Enum.map(&Regex.scan(~r/(\d+) (\w+)/, &1, capture: :all_but_first))
    |> Enum.map(
      &(&1
        |> Enum.into(%{"red" => 0, "blue" => 0, "green" => 0}, fn [number, color] ->
          {color, String.to_integer(number)}
        end))
    )
  end

  defp valid_game?({_game_id, sets}) do
    sets
    |> Enum.map(fn set ->
      Enum.map(set, fn color_count -> valid_set?(color_count) end)
    end)
    |> Enum.all?(&Enum.all?(&1))
  end

  defp valid_set?({color, number}) do
    cond do
      color == "red" && number > 12 -> false
      color == "green" && number > 13 -> false
      color == "blue" && number > 14 -> false
      true -> true
    end
  end

  defp game_ids({game_id, _sets}) do
    game_id
  end

  defp fewest_number_of_cubes({_game_id, sets}) do
    sets
    |> Enum.reduce(%{"blue" => 0, "green" => 0, "red" => 0}, fn set, acc ->
      Map.merge(acc, set, fn _key, value1, value2 ->
        Enum.max([value1, value2])
      end)
    end)
  end
end
