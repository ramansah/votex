defmodule Votex.Core do
  @moduledoc """
  Core functions to be used internally
  """

  import Ecto.Query
  alias Votex.{DB, Voter, Votable, Vote}

  def extract_fields(votable, voter) do
    {_, votable_type} =
      case votable do
        %{} = votable ->
          if not (Votable.children()
                  |> Enum.member?(votable.__struct__)),
             do: raise("Incompatible Votable")

          votable.__meta__.source

        _ ->
          {nil, nil}
      end

    {_, voter_type} =
      case voter do
        %{} = voter ->
          if not (Voter.children()
                  |> Enum.member?(voter.__struct__)),
             do: raise("Incompatible Voter")

          voter.__meta__.source

        _ ->
          {nil, nil}
      end

    {votable_type, voter_type}
  end

  def preload_votes(votes) do
    modules =
      Voter.children()
      |> convert_modules_list_to_map

    votes
    |> Enum.map(fn vote -> load_associations(vote, modules) end)
    |> Enum.filter(fn vote -> not is_nil(vote.voter) end)
  end

  def convert_modules_list_to_map(modules) do
    modules
    |> Enum.map(fn child ->
      {
        child.__struct__.__meta__.source
        |> Tuple.to_list()
        |> Enum.at(1),
        child
      }
    end)
    |> Enum.into(%{})
  end

  @spec calculate_cached_fields_for_votable(atom(), String.t(), integer(), boolean()) :: nil
  def calculate_cached_fields_for_votable(module, type, id, increment) do
    if module.__schema__(:fields) |> Enum.member?(:cached_votes_for_total) do
      record = DB.repo().get(module, id)

      cached_votes_for_total =
        case increment do
          true -> calculate_votes_for_votable(type, id)
          false -> record.cached_votes_for_total - 1
        end

      record
      |> module.changeset(%{cached_votes_for_total: cached_votes_for_total})
      |> DB.repo().update
    end
  end

  # Private

  defp calculate_votes_for_votable(type, id) do
    Vote
    |> where(votable_type: ^type)
    |> where(votable_id: ^id)
    |> DB.repo().all
    |> length
  end

  defp load_associations(vote, modules) do
    module =
      modules
      |> Map.get(vote.voter_type)

    vote
    |> Map.put(:voter, DB.repo().get(module, vote.voter_id))
  end
end
