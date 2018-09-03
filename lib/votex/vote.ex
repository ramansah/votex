defmodule Votex.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votex_votes" do
    field(:voter_type, :string)
    field(:votable_type, :string)
    field(:voter_id, :integer)
    field(:votable_id, :integer)

    timestamps()
  end

  @fields ~w(votable_type votable_id voter_type voter_id)a

  def changeset(vote, attrs) do
    vote
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
