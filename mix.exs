defmodule Deux.MixProject do
  use Mix.Project
  @version "0.1.0"

  def project do
    [
      app: :deux,
      version: @version,
      elixir: "~> 1.10",
      name: "Deux",
      description: "Status monitor for external services",
      source_url: "https://github.com/3zcurdia/deux",
      package: package(),
      docs: docs(),
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
      {:ex_doc, "~> 0.22", only: :docs},
      {:phoenix, ">= 1.4.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:tesla, "~> 1.3.0"},
      {:exredis, ">= 0.2.4"}
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp package() do
    [
      maintainers: ["Luis Ezcurdia"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/3zcurdia/deux"}
    ]
  end
end
