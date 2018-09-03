defmodule Votex do
  @moduledoc """
  Votex implements like / follow / vote methods for Ecto models. 
  Votex provides easy to use methods which can be used directly out of the box

  ### Features
  - Any model can be voted
  - Any model can vote
  - Supports self referential voting
  - Easy to understand syntax

  ### Configuration
  ```
  config :votex, Votex.DB,
    repo: MyApp.Repo
  ```

  Votex needs a table in DB to store votes information
  Install votex and generate votex schema migration

  ```
  mix votex.gen.migration
  mix ecto.migrate
  ```

  Modify the models in consideration

  #### user.ex
  ```
  defmodule MyApp.User do
    use Votex.Voter
  end
  ```

  #### post.ex
  ```
  defmodule MyApp.Post do
    use Votex.Votable
  end
  ```

  ### Usage
  ```
  post |> Post.vote_by user
  # {:ok, vote}

  user |> User.voted_for? post
  # true

  post |> Post.unvote_by user
  # {:ok, vote}
  ```
  """
end
