defmodule Votex.MixProject do
  use Mix.Project

  def project do
    [
      app: :votex,
      version: "0.3.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Votex",
      source_url: "https://github.com/ramansah/votex",
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
      {:ex_doc, "~> 0.19.1", only: :dev},
      {:ecto, "~> 2.1"},
      {:inch_ex, only: [:docs, :dev]}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/ramansah/votex",
        "Readme" => "https://github.com/ramansah/votex/blob/master/README.md"
      }
    ]
  end

  defp description() do
    "Implements vote / like / follow functionality for Ecto models in Elixir.
    Inspired from Acts as Votable"
  end

  defp docs() do
    [
      main: "readme",
      source_url: "https://github.com/ramansah/votex",
      extras: ["README.md"]
    ]
  end
end
