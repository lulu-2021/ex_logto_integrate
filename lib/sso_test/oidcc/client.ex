defmodule SsoTest.Oidcc.Client do
  @moduledoc """
  """

  alias SsoTest.Oidcc.{ClientConfig, Core}

  @doc """
  Signs in the user and returns the sign-in URI.
  The `redirect_uri` here is the redirect uri in our app
  """
  def sign_in(redirect_uri, code_challenge, code_verifier, state) do
    signin_options = ClientConfig.signin_options(code_challenge, state, redirect_uri)

    case Core.generate_sign_in_uri(signin_options) do
      {:ok, sign_in_uri} ->
        sign_in_session = %{
          redirect_uri: redirect_uri,
          code_verifier: code_verifier,
          code_challenge: code_challenge,
          state: state
        }

        IO.inspect sign_in_session, label: ">>> sign_in_session"
        {:ok, sign_in_session_json_value} = Jason.encode(sign_in_session)
        storage = %{} |> Map.put(:storage_key_sign_in_session, sign_in_session_json_value)
        IO.inspect storage, label: "session storage for later validation"

        {:ok, sign_in_uri}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def process_callback(redirect_uri, code_verifier, code) do
    options = %{
      token_endpoint: "http://localhost:3001/oidc/token/",
      client_id: "2a2yi37r08mv2ujr0dhf8",
      client_secret: "qPl7Oc8Dxi1VGDDJwYpKjlL7WX99Xemj",
      redirect_uri: redirect_uri,
      code_verifier: code_verifier,
      code: code,
    }
    SsoTest.Oidcc.Core.fetch_token_by_authorization_code(options)
  end

end
