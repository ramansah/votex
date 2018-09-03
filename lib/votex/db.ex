defmodule Votex.DB do
  @moduledoc false

  def repo do
    case :votex
         |> Application.fetch_env!(Votex.DB)
         |> Keyword.get(:repo) do
      nil -> raise("Specify repo in config")
      repo -> repo
    end
  end
end
