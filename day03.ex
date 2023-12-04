defmodule Day03 do
  def get_input() do
    case File.read("day03_input.txt") do
      {:ok, content} ->
        {:ok, content |> String.split("\n", trim: true)}

      _ ->
        IO.puts("Cannot read the file for some reason....")
        {:err}
    end
  end

  @doc """
  Output array of %{number: "100", range: 1..3}
  """
  def get_available_numbers(char_list, index \\ 0, current_number \\ "", number_list \\ [])

  def get_available_numbers([char | input], index, current_number, number_list)
      when char in ?0..?9 do
    next_index = index + 1

    get_available_numbers(
      input,
      next_index,
      current_number <> List.to_string([char]),
      number_list
    )
  end

  def get_available_numbers([_char | input], index, current_number, number_list) do
    next_index = index + 1

    case current_number do
      "" ->
        get_available_numbers(input, next_index, "", number_list)

      number_as_str ->
        number_as_int = String.to_integer(number_as_str)
        number_length = String.length(number_as_str)
        start_index = index - number_length

        get_available_numbers(input, next_index, "", [
          %{
            number: number_as_int,
            range: start_index..(index - 1)
          }
          | number_list
        ])
    end
  end

  def get_available_numbers([], _index, _current_number, number_list),
    do: number_list

  @doc """
  Returns a table that contains index of special chars for a given line
  """
  def get_available_signs(char_list, index \\ 0, signs_list \\ [])

  def get_available_signs([], _index, signs_list), do: signs_list

  def get_available_signs([char | input], index, signs_list) do
    next_index = index + 1

    cond do
      char in ?0..?9 or char == ?. ->
        get_available_signs(input, next_index, signs_list)

      true ->
        get_available_signs(input, next_index, [index | signs_list])
    end
  end

  @doc """
  Get the surrounding indexes for a number
  """
  def get_number_range(number_map) do
    first..last = number_map.range
    first_index = first - 1
    last_index = last + 1
    first_index..last_index
  end

  @doc """

  """
  def get_part_numbers(
        numbers,
        top_line_signs \\ [],
        current_line_signs \\ [],
        bottom_line_signs \\ []
      ) do
    numbers
    |> Enum.filter(fn number_map ->
      number_range = get_number_range(number_map)

      has_sign_on_top_line =
        top_line_signs |> Enum.any?(fn sign_idx -> sign_idx in number_range end)

      has_sign_on_current_line =
        bottom_line_signs |> Enum.any?(fn sign_idx -> sign_idx in number_range end)

      has_sign_on_bottom_line =
        current_line_signs |> Enum.any?(fn sign_idx -> sign_idx in number_range end)

      has_sign_on_bottom_line || has_sign_on_current_line || has_sign_on_top_line
    end)
    |> Enum.map(fn number_map -> number_map.number end)
  end

  @doc """
  Read the file and get a list of numbers that look like
  All indexes start to 0
  %{number: 100, range: 1..4, line: 0}
  """
  def run_part_1() do
    case get_input() do
      {:ok, content} ->
        [numbers_list, signs_list] =
          content
          |> Enum.reduce([[], []], fn line, [nb_list, s_list] ->
            char_list =
              line
              |> String.to_charlist()

            [
              [get_available_numbers(char_list) | nb_list],
              [get_available_signs(char_list) | s_list]
            ]
          end)
          |> Enum.map(fn v -> Enum.reverse(v) end)

        numbers_list
        |> Enum.slice(0..1)
        |> Enum.with_index()
        |> Enum.reduce([], fn {line_numbers, index}, acc ->
          new_numbers =
            get_part_numbers(
              line_numbers,
              Enum.at(signs_list, index - 1, []),
              Enum.at(signs_list, index),
              Enum.at(signs_list, index + 1, [])
            )

          dbg(index)
          dbg(new_numbers)

          [new_numbers | acc]
        end)
        |> Enum.flat_map(& &1)
        |> Enum.sum()

      _ ->
        IO.puts("oopsy")
    end
  end
end
