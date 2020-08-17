defmodule Deux.MixProject do
  use Mix.Project

  def project do
    [
      app: :deux,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {Deux.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, ">= 1.4.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:tesla, "~> 1.3.0"},
      {:exredis, ">= 0.2.4"}
    ]
  end
end
