defmodule ExAdvent.Day do
  defmacro __using__(opts) do
    day = Keyword.fetch!(opts, :day)
    parser = Keyword.fetch!(opts, :input)

    quote do
      def input(sample_or_input \\ :input) do
        binary = ExAdvent.Input.input_binary_for(unquote(day))
        unquote(parser).(binary)
      end

      def run(input_type \\ :input) do
        ExAdvent.Day.run(__MODULE__, input_type)
      end
    end
  end

  def run(module, input_type \\ :input) do
    [
      {module, :part_one, 1},
      {module, :part_two, 1}
    ]
    |> Enum.filter(fn {module, function, arity} ->
      function_exported?(module, function, arity)
    end)
    |> Enum.map(fn {module, function, _arity} ->
      {function, apply(module, function, [module.input(input_type)])}
    end)
  end
end
