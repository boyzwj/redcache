defmodule RedCache.MixProject do
  use Mix.Project

  def project do
    [
      app: :redcache,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exsync, "~> 0.3.0", only: :dev},
      {:redix, "~> 1.3"},
      {:poolboy, "~> 1.5"},
      {:jason, "~> 1.5.0-alpha.2"}
    ]
  end
end
