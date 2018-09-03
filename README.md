
# Votex

**Implements :thumbsup: vote / :heart: like / follow functionality for Ecto models in Elixir**

> Inspired from [Acts as Votable][acts_as_votable] :star: in Ruby on Rails

[acts_as_votable]: https://github.com/ryanto/acts_as_votable

## Features
  
- Any model can be voted
- Any model can vote
- Supports self referential voting
- Easy to understand syntax

## Installation

Add Votex to your project dependencies `mix.exs`

``` elixir
defp deps do
  [{:votex, "~> 0.2.0"}]
end
```

Specify your root project's repo in config

``` eixir
config :votex, Votex.DB,
  repo: MyApp.Repo
```

Votex needs a table in DB to store votes information. Install votex and generate votex schema migration

``` shell
mix deps.get
mix votex.gen.migration
mix ecto.migrate
```

## Usage

### Configure Models

``` elixir
defmodule User do
  use Ecto.Schema
  use Votex.Voter
end

defmodule Post do
  use Ecto.Schema
  use Votex.Votable
end
```

### Vote / Unvote

``` elixir
post |> Post.vote_by user
user |> User.voted_for? post
# true
post |> Post.votes_for |> length
# 1

post |> Post.votes_for
[
  %{
    id: 1,
    votable_id: 3,
    votable_type: "posts",
    voter: %Sample.User{
      id: 5,
      name: "John"
    },
    voter_id: 5,
    voter_type: "users"
  }
]

post |> Post.unvote_by user
```

### Self Referential Vote

``` elixir
defmodule User do
  use Ecto.Schema 
  use Votex.Voter
  use Votex.Votable
end

user2 |> User.vote_by user1
# {:ok, _}
```

