defmodule Votex.Votable do

  import Ecto.Query
  import Votex.Core
  alias Votex.{Vote, Votable, DB}


  defmacro __using__(_opts) do
    quote do
      defdelegate vote_by(votable, voter), to: Votable
      defdelegate unvote_by(votable, voter), to: Votable
      defdelegate votes_for(votable), to: Votable
		end
  end

  def vote_by(votable, voter) do
    { votable_type, voter_type } = extract_fields(votable, voter)
    %{
      votable_id: votable.id,
      votable_type: votable_type,
      voter_id: voter.id,
      voter_type: voter_type
    } |> create_vote
  end

  def unvote_by(votable, voter) do
    { votable_type, voter_type } = extract_fields(votable, voter)
    vote = Vote 
      |> where(votable_type: ^votable_type)
      |> where(votable_id: ^votable.id)
      |> where(voter_type: ^voter_type)
      |> where(voter_id: ^voter.id)
      |> DB.repo().one
    case vote do
      v -> v |> DB.repo().delete
      nil -> raise "Vote not present"
    end
  end

  def votes_for(votable) do
    { votable_type, _ } = extract_fields(votable, nil)
    votes = Vote
      |> where(votable_type: ^votable_type)
      |> where(votable_id: ^votable.id)
      |> DB.repo().all
      |> preload_votes
  end

  # Private

  defp create_vote(%{} = vote) do
    %Vote{}
      |> Vote.changeset(vote)
      |> DB.repo().insert
  end

end
