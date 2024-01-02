defmodule AdventOfCode2023.Output.Day4 do
  def solve(input) do
    %{
      part_1:
        input
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&to_winning_numbers_number(&1))
        |> Enum.map(&to_points(&1))
        |> Enum.sum(),
      part_2:
        input
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&to_winning_numbers_number(&1))
        |> total_score_card_count()
        |> Enum.map(& &1.card_count)
        |> Enum.sum()
    }
  end

  defp to_winning_numbers_number(line) do
    {_, numbers} =
      line
      |> String.split(": ")
      |> List.to_tuple()

    total =
      numbers |> String.split(" ") |> Enum.filter(&(&1 != "" and &1 != " " and &1 != "|"))

    uniques =
      total
      |> Enum.uniq()
      |> length()

    (total |> length) - uniques
  end

  defp to_points(num) do
    if num == 0 do
      0
    else
      2 ** (num - 1)
    end
  end

  defp total_score_card_count(list_of_matches) do
    initial_map =
      Enum.to_list(1..length(list_of_matches))
      |> Enum.map(fn card_num -> %{card_number: card_num, card_count: 1} end)

    list_of_matches
    |> Enum.with_index(fn matches, index -> {index + 1, matches} end)
    |> Enum.reduce(initial_map, fn {card_number, matches}, map_list ->
      how_many_cards_we_have =
        map_list
        |> Enum.filter(fn card -> card.card_number == card_number end)
        |> List.first()
        |> Map.get(:card_count)

      card_numbers_copied =
        if matches <= 0 do
          []
        else
          Enum.to_list((card_number + 1)..(card_number + matches))
          |> repeat(how_many_cards_we_have)
          |> List.flatten()
        end

      card_numbers_copied
      |> Enum.reduce(map_list, fn card_number, acc ->
        new_map =
          Map.update(Enum.at(acc, card_number - 1), :card_count, 1, &(&1 + 1))

        List.replace_at(
          acc,
          card_number - 1,
          new_map
        )
      end)
    end)
  end

  def repeat(element, times) do
    do_repeat(element, times, [])
  end

  defp do_repeat(_element, 0, acc), do: Enum.reverse(acc)
  defp do_repeat(element, times, acc), do: do_repeat(element, times - 1, [element | acc])
end
