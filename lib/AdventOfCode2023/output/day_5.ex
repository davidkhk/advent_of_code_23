defmodule AdventOfCode2023.Output.Day5 do
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

    almanac_1 =
      input
      |> String.trim()
      |> String.split("\n\n")
      |> to_almanac(:part_1)

    almanac_2 =
      input
      |> String.trim()
      |> String.split("\n\n")
      |> to_almanac(:part_2)

    %{
      part_1:
        almanac_1.seeds
        |> Enum.map(fn source_num ->
          from_source_to_destination(source_num, almanac_1.seeds_to_soil)
        end)
        |> Enum.map(fn source_num ->
          from_source_to_destination(source_num, almanac_1.soil_to_fertilizer)
        end)
        |> Enum.map(fn source_num ->
          from_source_to_destination(source_num, almanac_1.fertilizer_to_water)
        end)
        |> Enum.map(fn source_num ->
          from_source_to_destination(source_num, almanac_1.water_to_light)
        end)
        |> Enum.map(fn source_num ->
          from_source_to_destination(source_num, almanac_1.light_to_temperature)
        end)
        |> Enum.map(fn source_num ->
          from_source_to_destination(source_num, almanac_1.temperature_to_humidity)
        end)
        |> Enum.map(fn source_num ->
          from_source_to_destination(source_num, almanac_1.humidity_to_location)
        end)
        |> Enum.min(),
      part_2:
        almanac_2.seeds
        |> Enum.reduce(99999, &find_nearest_location(&1, &2, almanac_2))
    }
  end

  defp find_nearest_location(seed, min, almanac) do
    if seed.range == 0 do
      min
    else
      num =
        from_source_to_destination(seed.start + seed.range, almanac.seeds_to_soil)
        |> then(fn src -> from_source_to_destination(src, almanac.soil_to_fertilizer) end)
        |> then(fn src -> from_source_to_destination(src, almanac.fertilizer_to_water) end)
        |> then(fn src -> from_source_to_destination(src, almanac.water_to_light) end)
        |> then(fn src ->
          from_source_to_destination(src, almanac.light_to_temperature)
        end)
        |> then(fn src ->
          from_source_to_destination(src, almanac.temperature_to_humidity)
        end)
        |> then(fn src ->
          from_source_to_destination(src, almanac.humidity_to_location)
        end)

      if num < min do
        find_nearest_location(%{start: seed.start, range: seed.range - 1}, num, almanac)
      else
        find_nearest_location(%{start: seed.start, range: seed.range - 1}, min, almanac)
      end
    end
  end

  defp to_almanac(lines, :part_1) do
    seeds =
      lines
      |> List.first()
      |> String.split(": ")
      |> List.last()
      |> String.split(" ")
      |> Enum.map(&String.to_integer(&1))

    %{
      seeds: seeds,
      seeds_to_soil: to_map(0, lines),
      soil_to_fertilizer: to_map(1, lines),
      fertilizer_to_water: to_map(2, lines),
      water_to_light: to_map(3, lines),
      light_to_temperature: to_map(4, lines),
      temperature_to_humidity: to_map(5, lines),
      humidity_to_location: to_map(6, lines)
    }
  end

  defp to_almanac(lines, :part_2) do
    seeds =
      lines
      |> List.first()
      |> String.split(": ")
      |> List.last()
      |> String.split(" ")
      |> Enum.map(&String.to_integer(&1))
      |> Enum.chunk_every(2)
      |> Enum.map(&to_seed(&1))

    %{
      seeds: seeds,
      seeds_to_soil: to_map(0, lines),
      soil_to_fertilizer: to_map(1, lines),
      fertilizer_to_water: to_map(2, lines),
      water_to_light: to_map(3, lines),
      light_to_temperature: to_map(4, lines),
      temperature_to_humidity: to_map(5, lines),
      humidity_to_location: to_map(6, lines)
    }
  end

  defp to_seed(seed_nums) do
    {start, range} =
      seed_nums
      |> List.to_tuple()

    %{
      start: start,
      range: range
    }
  end

  defp to_map(index, lines) do
    [_ | tail] = lines

    tail
    |> Enum.map(fn map ->
      [_ | map_nums_str] =
        map
        |> String.split("\n")

      map_nums_str
      |> Enum.map(
        &(String.split(&1, " ")
          |> Enum.map(fn num_str -> String.to_integer(num_str) end))
      )
    end)
    |> Enum.at(index)
    |> Enum.map(fn map ->
      [destination_start, source_start, range_length] = map

      %{
        source_start: source_start,
        destination_start: destination_start,
        range_length: range_length
      }
    end)
  end

  defp from_source_to_destination(source_num, maps) do
    case maps
         |> Enum.map(&find_match(source_num, &1))
         |> Enum.filter(&(not is_nil(&1)))
         |> List.first() do
      nil ->
        source_num

      var ->
        var
    end
  end

  defp find_match(source_num, map) do
    if source_num >= map.source_start && source_num <= map.source_start + map.range_length - 1 do
      map.destination_start + (source_num - map.source_start)
    else
      nil
    end
  end
end
