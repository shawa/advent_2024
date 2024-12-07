defmodule Advent2024.Day07 do
  use ExAdvent.Day, day: 7, input: &Advent2024.Day07.Parser.parse/1
  # @operators [&Kernel.+/2, &Kernel.*/2]
  def part_one(equations) do
    equations
    |> Enum.filter(&valid/1)
    |> Enum.map(fn {value, _xs} -> value end)
    |> Enum.sum()
  end

  def build(xs, ops) do
    build_(Enum.reverse(xs), Enum.reverse(ops))
  end

  def valid({target, xs}) do
    number_ops = length(xs) - 1
    candidate_operators = [&Kernel.+/2, &Kernel.*/2]

    ops = generate(number_ops, candidate_operators)

    ops
    |> Enum.map(&build(xs, &1))
    |> Enum.map(&eval/1)
    |> Enum.any?(&(&1 == target))
  end

  def build_([x, y], [op]), do: {op, [x, y]}
  def build_([x | xs], [op | ops]), do: {op, [x, build_(xs, ops)]}

  def eval({fun, [x, y]}), do: fun.(eval(x), eval(y))
  def eval(x) when is_integer(x), do: x

  def generate(n, operators) do
    base = length(operators)

    operator_map =
      operators |> Enum.with_index() |> Map.new(fn {op, i} -> {i, op} end)

    target =
      for _ <- 1..n do
        "#{base - 1}"
      end
      |> Enum.join()
      |> :erlang.binary_to_integer(2)

    for i <- 0..target do
      i
      |> Integer.to_string(2)
      |> String.pad_leading(n, "0")
      |> String.to_charlist()
      |> Enum.map(&(&1 - ?0))
      |> Enum.map(&Map.fetch!(operator_map, &1))
    end
  end
end
