defmodule Breezex.MixProject do
  use Mix.Project

  @version "0.1.0"
  def project do
    [
      app: :breezex,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      description: "A wrapper client for the Breeze Church Management System's API"
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
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:httpoison, "~> 1.7"},
      {:poison, "~> 4.0"}
    ]
  end

  defp package do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/elixir-ecto/postgrex"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "Breezex",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/breezex",
      source_url: "https://github.com/maco/breezex",
      extras: [
        "README.md"
      ]
    ]
  end
end
