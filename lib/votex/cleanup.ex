defmodule Votex.CleanupBehaviour do
  @moduledoc """
  Behavior provider for cleanup_votes
  """

  @callback cleanup_votes(tuple()) :: tuple()
end
