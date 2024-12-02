defmodule Advent2024.Day02.Parser do
  import NimbleParsec

  @type t() :: [Nx.Tensor.t()]

  whitespace = ignore(ascii_char([32..32]) |> times(min: 1))
  newline = ignore(ascii_char([?\n..?\n]))

  line =
    times(
      integer(min: 1)
      |> concat(whitespace),
      min: 1
    )
    |> integer(min: 1)
    |> concat(newline)
    |> tag(:row)

  report =
    times(line, min: 1)

  defparsec :report, report

  @spec parse(binary()) :: t()
  def parse(input) do
    {:ok, results, "", _, _, _} = report(input)

    results
    |> Enum.map(fn {:row, xs} ->
      Nx.tensor(xs)
    end)
  end
end
