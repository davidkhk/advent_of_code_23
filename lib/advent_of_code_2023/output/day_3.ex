defmodule AdventOfCode2023.Output.Day3 do
  def solve(input) do
    %{
      part_1:
        input
        |> String.trim()
        |> String.split("\n")
        |> Enum.with_index(fn element, index -> {index, element} end)
        |> Enum.flat_map(&to_coordinate_char_pairs(&1))
        |> Enum.filter(&is_not_period_char(&1))
        |> to_schematic(:part_1)
        |> to_numbers_with_adjacent_symbols(:part_1),
      part_2:
        input
        |> String.trim()
        |> String.split("\n")
        |> Enum.with_index(fn element, index -> {index, element} end)
        |> Enum.flat_map(&to_coordinate_char_pairs(&1))
        |> Enum.filter(&is_not_period_char(&1))
        |> to_schematic(:part_2)
        |> to_numbers_with_adjacent_symbols(:part_2)
        |> group_by_adjacent_symbols()
        |> Map.to_list()
        |> Enum.filter(fn {_, nums} -> length(nums) == 2 end)
        |> Enum.map(&elem(&1, 1))
        |> Enum.map(&Enum.product(&1))
        |> Enum.sum()
    }
  end

  # PARSING STRING

  defp to_coordinate_char_pairs({y, line}) do
    line
    |> String.graphemes()
    |> Enum.with_index(fn element, x ->
      {{x, y}, element}
    end)
  end

  defp is_not_period_char({_, char}) do
    char != "."
  end

  defp to_schematic(coordinate_char_list, :part_1) do
    %{
      numbers: to_numbers(coordinate_char_list),
      symbols: to_symbols(:part_1, coordinate_char_list)
    }
  end

  defp to_schematic(coordinate_char_list, :part_2) do
    %{
      numbers: to_numbers(coordinate_char_list),
      symbols: to_symbols(:part_2, coordinate_char_list)
    }
  end

  defp to_numbers(coordinate_char_list) do
    coordinate_char_list
    |> Enum.filter(&is_digit(&1))
    |> Enum.reduce(
      %{last: nil, numbers: []},
      &update_numbers(&1, &2)
    )
    |> from_number_info_to_number_at_rante_list
  end

  defp update_numbers({{x, y}, char}, acc) do
    case acc.last do
      nil ->
        acc
        |> Map.put(:last, %{chars: [char], y: y, x_start: x, x_end: x})

      last ->
        if last.x_end == x - 1 do
          acc
          |> put_in([:last, :chars], last.chars ++ [char])
          |> put_in([:last, :x_end], x)
        else
          acc
          |> Map.put(:numbers, acc.numbers ++ from_last_to_number_at_range(last))
          |> Map.put(:last, %{chars: [char], y: y, x_start: x, x_end: x})
        end
    end
  end

  defp from_number_info_to_number_at_rante_list(number_info) do
    case number_info.last do
      nil ->
        number_info.numbers

      last ->
        number_info.numbers ++ from_last_to_number_at_range(last)
    end
  end

  defp from_last_to_number_at_range(last) do
    num =
      last.chars
      |> Enum.join()
      |> String.to_integer()

    [
      %{
        number: num,
        x_range: {last.x_start, last.x_end},
        y: last.y
      }
    ]
  end

  defp to_symbols(:part_1, coordinate_char_list) do
    coordinate_char_list
    |> Enum.filter(&is_symbol(&1))
    |> Enum.map(&elem(&1, 0))
    |> MapSet.new()
  end

  defp to_symbols(:part_2, coordinate_char_list) do
    coordinate_char_list
    |> Enum.filter(&is_star(&1))
    |> Enum.map(&elem(&1, 0))
    |> MapSet.new()
  end

  defp is_symbol(pair) do
    not is_digit(pair)
  end

  defp is_star({_, char}) do
    char == "*"
  end

  defp is_digit({_, char}) do
    Regex.match?(~r/\d/, char)
  end

  # CHECKING THE SCHEMATIC

  defp to_numbers_with_adjacent_symbols(schematic, :part_1) do
    schematic.numbers
    |> Enum.filter(&has_adjacent_symbol(:part_1, schematic, &1))
    |> Enum.map(& &1.number)
    |> Enum.sum()
  end

  defp to_numbers_with_adjacent_symbols(schematic, :part_2) do
    schematic.numbers
    |> Enum.map(&has_adjacent_symbol(:part_2, schematic, &1))
    |> Enum.filter(&(not Enum.empty?(&1.symbols)))
  end

  defp has_adjacent_symbol(:part_1, schematic, number_at_range) do
    Enum.to_list(elem(number_at_range.x_range, 0)..elem(number_at_range.x_range, 1))
    |> Enum.map(fn x -> {x, number_at_range.y} end)
    |> Enum.flat_map(&to_adjacent_coordinate(&1))
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.filter(fn coordinate -> MapSet.member?(schematic.symbols, coordinate) end)
  end

  defp has_adjacent_symbol(:part_2, schematic, number_at_range) do
    %{
      symbols: has_adjacent_symbol(:part_1, schematic, number_at_range),
      number: number_at_range.number
    }
  end

  defp to_adjacent_coordinate({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  defp group_by_adjacent_symbols(numbers) do
    numbers
    |> Enum.group_by(
      &(&1.symbols |> List.first()),
      & &1.number
    )
  end
end
