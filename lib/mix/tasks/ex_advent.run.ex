defmodule Mix.Tasks.ExAdvent.Run do
  use Mix.Task

  def run([]) do
    {:ok, all_modules} =
      :application.get_key(:advent_2024, :modules)

    all_modules
    |> Enum.filter(fn module ->
      match?(<<"Elixir.Advent2024.Day", _::binary-size(2)>>, Atom.to_string(module))
    end)
    |> Enum.map(&apply(&1, :run, []))
    |> Enum.with_index(1)
    |> Enum.map(fn {output, i} ->
      %{
        "Day" => i,
        "Part One" => Keyword.get(output, :part_one, "Not complete"),
        "Part Two" => Keyword.get(output, :part_two, "Not complete")
      }
    end)
    |> Scribe.print()
  end
end
