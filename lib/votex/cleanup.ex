defmodule Votex.CleanupBehaviour do
  @moduledoc false

  @callback cleanup_votes(tuple()) :: tuple()
end
