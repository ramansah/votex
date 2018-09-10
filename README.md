<p align="center">
  <a href="https://travis-ci.org/ramansah/votex">
    <img src="https://api.travis-ci.org/ramansah/votex.svg" alt="travis" title="build-status"/>
  </a>
</p>

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
  [{:votex, "~> 0.3.0"}]
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

### Cleanup

Since polymorphic associations are not supported in Ecto and callbacks are deprecated, orphan votes need to be cleared when a parent entity is destroyed. Therefore, you need to call cleanup_votes when you delete a Voter or a Votable record.

``` elixir
# Delete user
Repo.delete(user) |> User.cleanup_votes

# Delete post
Repo.delete(post) |> Post.cleanup_votes
```

### Cache Support

Some fields like total number of votes on a post can be cached in posts table to avoid extra calls to DB. Votex will update the field if present in schema.

``` elixir
defmodule Post do
  use Ecto.Schema
  use Votex.Votable

  schema "posts" do
    field(:cached_votes_for_total, :integer)
  end

  @fields ~w(cached_votes_for_total)a

  # Publicly accessible changeset for Votex to update field
  def changeset(post, attrs) do
    post
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
```

The posts table will track total votes from now on

``` elixir
post |> Post.vote_by user
post = Repo.get(Post, 1)
post.cached_votes_for_total
# 5
```
