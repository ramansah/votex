defmodule Votex.Core do
  
  alias Votex.{DB, Voter}


  def extract_fields(votable, voter) do
    { _, votable_type } = case votable do
      %{} = votable -> votable.__meta__.source
      _ -> { nil, nil }
    end
    { _, voter_type } = case voter do
      %{} = voter -> voter.__meta__.source
      _ -> { nil, nil }
    end
    { votable_type, voter_type }
  end

  def preload_votes(votes) do
    modules = Voter.children()
      |> Enum.map(fn child -> { 
          child.__struct__.__meta__.source 
            |> Tuple.to_list 
            |> Enum.at(1),
          child
        } end)
      |> Enum.into %{}

    votes
        |> Enum.map(fn vote -> load_associations(vote, modules) end)
        |> Enum.filter(fn vote -> not is_nil(vote.voter) end)
  end


  # Private

  defp load_associations(vote, modules) do
    module = modules
      |> Map.get(vote.voter_type)
    vote
      |> Map.put(:voter, DB.repo().get(module, vote.voter_id))
  end

end
