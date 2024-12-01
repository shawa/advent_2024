defmodule Advent2024.Day01.Parser do
  import NimbleParsec
  @type t() :: {[integer()], [integer()]}

  whitespace =
    ascii_char([32..32])
    |> times(min: 1)

  line =
    integer(min: 1)
    |> ignore(whitespace)
    |> integer(min: 1)
    |> ignore(ascii_char([?\n..?\n]))
    |> tag(:row)

  lists = times(line, min: 1)
  defparsec :lists, lists

  @spec parse!(binary) :: t()
  def parse!(input) do
    {:ok, results, "", _, _, _} = lists(input)

    results
    |> Enum.map(fn {:row, [a, b]} -> {a, b} end)
    |> Enum.unzip()
  end
end

defmodule Advent2024.Day01 do
  alias Advent2024.Day01.Parser
  use ExAdvent.Day, day: 1, input: &Parser.parse!/1

  @spec part_one(Parser.t()) :: integer()
  def part_one({left, right}) do
    Enum.zip_with(
      Enum.sort(left),
      Enum.sort(right),
      &abs(&2 - &1)
    )
    |> Enum.sum()
  end

  @spec part_two(Parser.t()) :: integer()
  def part_two({left, right}) do
    freqs = Enum.frequencies(right)

    left
    |> Enum.map(&(&1 * Map.get(freqs, &1, 0)))
    |> Enum.sum()
  end
end
