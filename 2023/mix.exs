defmodule Aoc2023.MixProject do
  use Mix.Project

  def project do
    paths =
      File.ls!()
      |> Enum.filter(&Regex.match?(~r/^\d\d-/, &1))

    [
      app: :aoc2023,
      version: "2023.0.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      test_paths: ["."],
      elixirc_paths: paths ++ ["lib"]
    ]
  end
end
