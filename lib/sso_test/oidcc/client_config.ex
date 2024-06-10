defmodule SsoTest.Oidcc.ClientConfig do
  @moduledoc """
  """

  @authorization_endpoint "http://localhost:3001/oidc/auth/"
  @client_id "2a2yi37r08mv2ujr0dhf8"
  @prompt "consent"

  def signin_options(code_challenge, state, redirect_uri) do
    %{
      code_challenge: code_challenge,
      authorization_endpoint: @authorization_endpoint,
      client_id: @client_id,
      redirect_uri: redirect_uri,
      state: state,
      scopes: ["openid"],
      resources: [],
      prompt: @prompt
    }
  end
end
