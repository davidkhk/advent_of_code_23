defmodule AdventOfCode2023.Output.Day1 do
  @numbers ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
  def calibration_value_sum(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn calibration_text ->
      calibration_text
      |> String.replace(@numbers, fn text ->
        case text do
          "one" -> "oonee"
          "two" -> "ttwoo"
          "three" -> "tthreee"
          "four" -> "ffourr"
          "five" -> "ffivee"
          "six" -> "ssixx"
          "seven" -> "ssevenn"
          "eight" -> "eeightt"
          "nine" -> "nninee"
        end
      end)
    end)
    |> Enum.map(fn calibration_text ->
      calibration_text
      |> String.replace(@numbers, fn text ->
        case text do
          "one" -> "1"
          "two" -> "2"
          "three" -> "3"
          "four" -> "4"
          "five" -> "5"
          "six" -> "6"
          "seven" -> "7"
          "eight" -> "8"
          "nine" -> "9"
        end
      end)
    end)
    |> Enum.map(&extract_first_and_last/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp extract_first_and_last(string) do
    string
    |> String.replace(~r/[a-z]/, "")
    |> String.graphemes()
    |> do_extract_first_and_last
  end

  defp do_extract_first_and_last(graphemes) do
    first = List.first(graphemes, "0")
    last = List.last(graphemes, "0")

    {first, last}
    |> Tuple.to_list()
    |> Enum.join()
    |> String.to_integer()
  end
end
