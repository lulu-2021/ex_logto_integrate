defmodule SsoTest.Oidcc.Token do
  @moduledoc """

  """

  @type id_token_claims :: map()

  @doc """
  Decodes a given JWT token and returns the claims.

  ## Parameters
  - token: The JWT token as a string.

  ## Returns
  - {:ok, id_token_claims} on success.
  - {:error, reason} on failure.
  """
  def decode_id_token(token), do: JOSE.JWS.peek_payload(token)
end
