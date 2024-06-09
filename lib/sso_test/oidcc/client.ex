defmodule SignInSession do
  defstruct redirect_uri: "", code_verifier: "", code_challenge: "", state: ""
end

defmodule LogtoClient do
  defstruct logto_config: %{}, storage: %{}
end

defmodule SsoTest.Oidcc.Client do
  @moduledoc """
  """
  import SsoTest.Oidcc.Generator

  @doc """
  Signs in the user and returns the sign-in URI.
  The `redirect_uri` here is the redirect uri in our app
  """
  def sign_in(%LogtoClient{} = _logto_client, redirect_uri) do
    code_verifier = generate_code_verifier()
    code_challenge = generate_code_challenge(code_verifier)
    state = generate_state()
    signin_options = SsoTest.Oidcc.ClientConfig.signin_options(code_challenge, state, redirect_uri)

    case SsoTest.Oidcc.Core.generate_sign_in_uri(signin_options) do
      {:ok, sign_in_uri} ->
        sign_in_session = %SignInSession{
          redirect_uri: redirect_uri,
          code_verifier: code_verifier,
          code_challenge: code_challenge,
          state: state
        }

        IO.inspect sign_in_session, label: ">>> sign_in_session"

        #{:ok, sign_in_session_json_value} = Jason.encode(sign_in_session)
        #logto_client.storage |> Map.put(:storage_key_sign_in_session, sign_in_session_json_value)

        {:ok, sign_in_uri}
      {:error, reason} ->
        {:error, reason}
    end
  end
end
