defmodule Votex.Voter do

  import Ecto.Query
  import Votex.Core
  alias Votex.{Vote, Voter, DB}


  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
      defdelegate votes_by(voter), to: Voter
      defdelegate voted_for?(voter, votable), to: Voter
		end
	end


  def votes_by(%{} = voter, preload \\ false) do
    { _, voter_type } = extract_fields(nil, voter)
    Vote 
      |> where(voter_type: ^voter_type)
      |> where(voter_id: ^voter.id)
      |> DB.repo().all()
  end

  def voted_for?(%{} = voter, %{} = votable) do
    { votable_type, voter_type } = extract_fields(votable, voter)
    case Vote 
        |> where(voter_type: ^voter_type)
        |> where(voter_id: ^voter.id)
        |> where(votable_type: ^votable_type)
        |> where(votable_id: ^votable.id)
        |> DB.repo().one() 
      do
        %{} -> true
        nil -> false
    end
  end

  def children() do
    (for {module, _} <- :code.all_loaded(), do: module)
    |> Enum.filter(&is_child?/1)
  end

  # Private

  defp is_child?(module) do
    module.module_info[:attributes]
    |> Keyword.get(:behaviour, [])
    |> Enum.member?(__MODULE__)
  end

end