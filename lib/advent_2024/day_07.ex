defmodule Advent2024.Day07 do
  use ExAdvent.Day, day: 7, input: &Advent2024.Day07.Parser.parse/1

  def part_one(input) do
    solve(input, 1)
  end

  def part_two(input) do
    solve(input, 2)
  end

  def operators_for(1), do: [&Kernel.+/2, &Kernel.*/2]

  def operators_for(2) do
    [(&:erlang.binary_to_integer("#{&1}#{&2}")) | operators_for(1)]
  end

  def solve(equations, part) do
    operators = operators_for(part)

    equations
    |> Task.async_stream(&{&1, valid(&1, operators)})
    |> Stream.map(fn
      {
        :ok,
        {{target, _terms}, valid}
      } ->
        {target, valid}
    end)
    |> Enum.filter(fn {_target, valid} -> valid end)
    |> Enum.map(fn {target, _valid} -> target end)
    |> Enum.sum()
  end

  def valid({target, xs}, candidate_operators) do
    ops = generate(length(xs) - 1, candidate_operators)

    ops
    |> Enum.map(&interzip(xs, &1))
    |> Enum.map(&eval/1)
    |> Enum.any?(&(&1 == target))
  end

  def eval([n]) when is_integer(n), do: n
  def eval([x, fun, y | rest]), do: eval([fun.(x, y) | rest])
  def interzip([x], []), do: [x]
  def interzip([x | xs], [fun | funs]), do: [x, fun | interzip(xs, funs)]

  def generate(n, operators) do
    operator_map =
      Map.new(
        Enum.with_index(operators),
        fn {op, i} -> {i, op} end
      )

    base = length(operators)
    target = trunc(:math.pow(base, n) - 1)

    for i <- 0..target do
      i
      |> Integer.to_charlist(base)
      |> pad_leading(n)
      |> Enum.map(&Map.fetch!(operator_map, &1 - ?0))
    end
  end

  def pad_leading(xs, n) do
    diff = max(n - length(xs), 0)
    pad(xs, diff)
  end

  def pad(xs, 0), do: xs
  def pad(xs, n), do: pad([?0 | xs], n - 1)
end
