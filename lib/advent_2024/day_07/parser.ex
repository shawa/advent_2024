defmodule Advent2024.Day07.Parser do
  import NimbleParsec

  line =
    tag(integer(min: 1), :target)
    |> ignore(string(":"))
    |> tag(
      times(
        ignore(string(" ")) |> integer(min: 1),
        min: 1
      ),
      :numbers
    )
    |> ignore(string("\n"))

  input =
    line
    |> tag(:line)
    |> times(min: 1)

  defparsec :parse_input, input

  def parse(input) do
    {:ok, results, "", _context, _line, _column} = parse_input(input)

    Enum.map(results, fn {:line, [target: [target], numbers: numbers]} -> {target, numbers} end)
  end
end
