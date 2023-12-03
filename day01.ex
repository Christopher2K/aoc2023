defmodule Day01 do
  def get_input() do
    case File.read("day01_input.txt") do
      {:ok, content} ->
        parsed_content = content |> String.split("\n", trim: true)
        {:ok, parsed_content}

      _ ->
        IO.puts("Cannot read the file for some reason....")
        {:err}
    end
  end

  def get_line_code(line) do
    numbers =
      line |> String.to_charlist() |> Enum.filter(fn letter -> letter in ?0..?9 end)

    {first_number, last_number} = {hd(numbers), List.last(numbers)}

    List.to_integer([first_number, last_number])
  end

  def replace_string_by_numbers(""), do: ""
  def replace_string_by_numbers("one" <> rest), do: "1" <> replace_string_by_numbers("e" <> rest)
  def replace_string_by_numbers("two" <> rest), do: "2" <> replace_string_by_numbers("o" <> rest)

  def replace_string_by_numbers("three" <> rest),
    do: "3" <> replace_string_by_numbers("e" <> rest)

  def replace_string_by_numbers("four" <> rest), do: "4" <> replace_string_by_numbers("r" <> rest)
  def replace_string_by_numbers("five" <> rest), do: "5" <> replace_string_by_numbers("e" <> rest)
  def replace_string_by_numbers("six" <> rest), do: "6" <> replace_string_by_numbers("x" <> rest)

  def replace_string_by_numbers("seven" <> rest),
    do: "7" <> replace_string_by_numbers("n" <> rest)

  def replace_string_by_numbers("eight" <> rest),
    do: "8" <> replace_string_by_numbers("t" <> rest)

  def replace_string_by_numbers("nine" <> rest), do: "9" <> replace_string_by_numbers("e" <> rest)

  def replace_string_by_numbers(<<letter, rest::binary>>),
    do: <<letter>> <> replace_string_by_numbers(rest)

  def run_part_1() do
    case get_input() do
      {:ok, content} ->
        content |> Enum.map(&get_line_code/1) |> Enum.sum()

      _ ->
        IO.puts("Oopsy")
    end
  end

  def run_part_2() do
    case get_input() do
      {:ok, content} ->
        content
        |> Enum.map(&replace_string_by_numbers/1)
        |> Enum.map(&get_line_code/1)
        |> Enum.sum()

      _ ->
        IO.puts("Oopsy")
    end
  end
end
