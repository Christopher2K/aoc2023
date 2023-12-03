defmodule Day02 do
  def get_input() do
    case File.read("day02_input.txt") do
      {:ok, content} ->
        {:ok, content |> String.split("\n", trim: true) |> Enum.map(&convert_line_to_game_map/1)}

      _ ->
        IO.puts("Cannot read the file for some reason....")
        {:err}
    end
  end

  def convert_line_to_game_map(line) do
    [game_definition, subsets_definition] = line |> String.split(": ")
    {game_id, ""} = game_definition |> String.split(" ") |> Enum.at(1) |> Integer.parse()

    subsets =
      subsets_definition
      |> String.split("; ")
      |> Enum.map(fn subset ->
        subset
        |> String.split(", ")
        |> Enum.map(fn cube_definition ->
          cube_definition |> String.split(" ")
        end)
        |> Enum.reduce(%{}, fn [cube_number, cube_color], acc ->
          {parsed_nb, ""} = Integer.parse(cube_number)
          acc |> Map.put(String.to_atom(cube_color), parsed_nb)
        end)
      end)

    %{
      game_id: game_id,
      subsets: subsets
    }
  end

  def run_part_1() do
    case get_input() do
      {:ok, content} ->
        content
        |> Enum.filter(fn game_map ->
          game_map.subsets
          |> Enum.all?(fn subset ->
            under_red_cap = !Map.has_key?(subset, :red) || subset.red <= 12

            under_green_cap =
              !Map.has_key?(subset, :green) || subset.green <= 13

            under_blue_cap = !Map.has_key?(subset, :blue) || subset.blue <= 14

            under_blue_cap && under_green_cap && under_red_cap
          end)
        end)
        |> Enum.map(fn game_map -> game_map.game_id end)
        |> Enum.sum()

      _ ->
        IO.puts("Oopsy")
    end
  end

  def run_part_2() do
    case get_input() do
      {:ok, content} ->
        content
        |> Enum.map(fn game_map ->
          game_map.subsets
          |> Enum.reduce(%{blue: 1, red: 1, green: 1}, fn subset, acc ->
            blue_value =
              if acc.blue > Map.get(subset, :blue, 0),
                do: acc.blue,
                else: subset.blue

            red_value =
              if acc.red > Map.get(subset, :red, 0),
                do: acc.red,
                else: subset.red

            green_value =
              if acc.green > Map.get(subset, :green, 0),
                do: acc.green,
                else: subset.green

            %{
              blue: blue_value,
              red: red_value,
              green: green_value
            }
          end)
        end)
        |> Enum.map(fn %{green: green, red: red, blue: blue} -> green * red * blue end)
        |> Enum.sum()

      _ ->
        IO.puts("Oopsy")
    end
  end
end
