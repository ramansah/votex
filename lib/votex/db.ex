defmodule Votex.DB do

  def repo do
    case :votex
        |> Application.fetch_env!(Votex.DB)
        |> Keyword.get(:repo)
      do
        repo -> repo
        nil -> raise("Specify repo in config")
    end
  end

end
