defmodule Votex.Votable do

  @moduledoc """
  Defines a Votable Model

  A Votable model will expose the required methods to enable voting functionality
  Typically be used by models like Post, Image, Answer etc.

  ## Example
    defmodule Post do  
      use Ecto.Schema 
      use Votex.Votable
      schema "posts" do 
        field :title, :string 
        field :views, :integer, default:  0 
      end  
    end
  """

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

  @doc """
  Primary method to cast a vote

  ## Example
    {:ok, vote} = post |> Post.vote_by user
  """

  def vote_by(votable, voter) do
    { votable_type, voter_type } = extract_fields(votable, voter)
    %{
      votable_id: votable.id,
      votable_type: votable_type,
      voter_id: voter.id,
      voter_type: voter_type
    } |> create_vote
  end

  @doc """
  Primary method to remove a vote

  ## Example
    {:ok, vote} = post |> Post.unvote_by user
  """

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

  @doc """
  Get a list of votes on votable record

  ## Example
    votes = post |> Post.votes_for
  """

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
