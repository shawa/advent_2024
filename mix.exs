defmodule ExAdvent.MixProject do
  use Mix.Project

  def project do
    [
      name: "Advent of Code 2024",
      source_url: "https://github.com/shawa/advent_2024",
      app: :advent_2024,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nx, "~> 0.9"},
      {:nimble_parsec, "~> 1.4"},
      {:ex_doc, "~> 0.35.1"},
      {:stream_data, "~> 1.1.2"},
      {:libgraph, "~> 0.16"}
    ]
  end

  defp docs do
    [
      extras: ["README.md" | Path.wildcard("problems/*.md")],
      main: "README",
      logo: "logo.svg"
    ]
  end
end
