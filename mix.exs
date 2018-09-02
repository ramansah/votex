defmodule Votex.MixProject do
  use Mix.Project

  def project do
    [
      app: :votex,
      version: "0.2.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Votex",
      source_url: "https://github.com/ramansah/votex"
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
    ]
  end

  defp package() do
    [
      files: ~w(lib priv .formatter.exs mix.exs README*),
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/ramansah/votex"}
    ]
  end

  defp description() do
    "Implements vote / like / follow functionality for Ecto models.
    Inspired from Acts as Votable"
  end

end
