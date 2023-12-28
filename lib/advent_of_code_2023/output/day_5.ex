defmodule AdventOfCode2023.Output.Day5 do
  @type almanac :: %{
          seeds: list(integer),
          seeds_to_soil:
            list(%{source_start: integer, destination_start: integer, range_length: integer}),
          soil_to_fertilizer:
            list(%{source_start: integer, destination_start: integer, range_length: integer}),
          fertilizer_to_water:
            list(%{source_start: integer, destination_start: integer, range_length: integer}),
          water_to_light:
            list(%{source_start: integer, destination_start: integer, range_length: integer}),
          light_to_temperature:
            list(%{source_start: integer, destination_start: integer, range_length: integer}),
          temperature_to_humidity:
            list(%{source_start: integer, destination_start: integer, range_length: integer}),
          humidity_to_location:
            list(%{source_start: integer, destination_start: integer, range_length: integer})
        }
  def solve() do
    input = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

    input
  end
end
