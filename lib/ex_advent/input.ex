defmodule ExAdvent.Input do
  @spec input_binary_for(integer()) :: binary()
  def input_binary_for(day) do
    day
    |> filepath_for()
    |> File.read!()
  end

  defp filepath_for(day) do
    Path.join([
      :code.priv_dir(:advent_2024),
      "input",
      pad(day),
      "input.txt"
    ])
  end

  defp pad(n) do
    n
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
