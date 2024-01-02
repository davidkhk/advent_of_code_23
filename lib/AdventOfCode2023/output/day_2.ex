defmodule AdventOfCode2023.Output.Day2 do
  def solve(input) do
    %{
      part_1:
        input
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&to_game(&1))
        |> Enum.filter(&is_valid(:one, &1))
        |> Enum.map(& &1["id"])
        |> Enum.sum(),
      part_2:
        input
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&to_game(&1))
        |> Enum.map(&is_valid(:two, &1))
        |> Enum.sum()
    }
  end

  defp to_game(line) do
    {game_with_id, round_str} =
      line
      |> String.split(": ")
      |> List.to_tuple()

    id =
      game_with_id
      |> String.split(" ")
      |> List.last()
      |> String.to_integer()

    rounds =
      round_str
      |> String.split("; ")
      |> Enum.map(&String.split(&1, ", "))
      |> Enum.map(fn string_list ->
        string_list
        |> to_round()
      end)

    %{
      "id" => id,
      "rounds" => rounds
    }
  end

  defp to_round(strings) do
    Enum.reduce(strings, %{red: 0, blue: 0, green: 0}, fn round, acc ->
      case String.split(round, " ") |> List.to_tuple() do
        {num, "red"} ->
          acc
          |> Map.update(:red, 0, &(&1 + String.to_integer(num)))

        {num, "green"} ->
          acc
          |> Map.update(:green, 0, &(&1 + String.to_integer(num)))

        {num, "blue"} ->
          acc
          |> Map.update(:blue, 0, &(&1 + String.to_integer(num)))
      end
    end)
  end

  defp is_valid(:one, game) do
    max_red =
      game["rounds"]
      |> Enum.map(& &1.red)
      |> Enum.max()

    max_green =
      game["rounds"]
      |> Enum.map(& &1.green)
      |> Enum.max()

    max_blue =
      game["rounds"]
      |> Enum.map(& &1.blue)
      |> Enum.max()

    max_red <= 12 && max_green <= 13 && max_blue <= 14
  end

  defp is_valid(:two, game) do
    max_red =
      game["rounds"]
      |> Enum.map(& &1.red)
      |> Enum.max()

    max_green =
      game["rounds"]
      |> Enum.map(& &1.green)
      |> Enum.max()

    max_blue =
      game["rounds"]
      |> Enum.map(& &1.blue)
      |> Enum.max()

    max_red * max_green * max_blue
  end
end
