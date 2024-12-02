defmodule Advent2024.Day02 do
  alias Advent2024.Day02.Parser
  use ExAdvent.Day, day: 2, input: &Parser.parse/1

  import Nx
  import Nx.Defn

  @spec part_one(Parser.t()) :: integer()
  def part_one(tensors) do
    tensors
    |> Enum.count(&safe/1)
  end

  @spec part_two(Parser.t()) :: integer()
  def part_two(tensors) do
    tensors
    |> Enum.map(&explode/1)
    |> Enum.count(&(part_one(&1) >= 1))
  end

  def safe(t), do: t |> checks() |> Nx.to_binary() == <<1>>

  defn checks(t) do
    deltas = deltas(t)
    magnitude = abs(deltas)

    (all(deltas > 0) or all(deltas < 0)) and
      all(magnitude >= 1 and magnitude <= 3)
  end

  defn deltas(t) do
    {len} = shape(t)
    left = slice(t, [0], [len - 1])
    right = slice(t, [1], [len - 1])

    right - left
  end

  defp explode(t) do
    {len} = shape(t)
    zeroes = linspace(0, 0, n: len, type: type(t))

    # 1, 2, 3
    t
    # 1, 2, 3
    # 1, 2, 3
    # 1, 2, 3
    |> broadcast({len, len})
    # 0, 2, 3
    # 1, 0, 3
    # 1, 2, 0
    |> put_diagonal(zeroes)
    |> to_list()
    # 2, 3
    # 1, 3
    # 1, 2
    |> Enum.map(fn xs ->
      xs
      |> Enum.filter(&(&1 != 0))
      |> tensor()
    end)
  end
end
