defmodule LogtoClient do
  defstruct logto_config: %{}, storage: %{}
end

defmodule SsoTest.Oidcc.Client do
  @moduledoc """
  """
  import SsoTest.Oidcc.Generator
  import SsoTest.Oidcc.RequestUtils

  @storage_key_sign_in_session "StorageKeySignInSession"

  @doc """
  Signs in the user and returns the sign-in URI.
  The `redirect_uri` here is the redirect uri in our app
  """
  def sign_in(redirect_uri) do
    code_verifier = generate_code_verifier()
    code_challenge = generate_code_challenge(code_verifier)
    state = generate_state()
    signin_options = SsoTest.Oidcc.ClientConfig.signin_options(code_challenge, state, redirect_uri)

    case SsoTest.Oidcc.Core.generate_sign_in_uri(signin_options) do
      {:ok, sign_in_uri} ->
        sign_in_session = %{
          redirect_uri: redirect_uri,
          code_verifier: code_verifier,
          code_challenge: code_challenge,
          state: state
        }

        IO.inspect sign_in_session, label: ">>> sign_in_session"

        {:ok, sign_in_session_json_value} = Jason.encode(sign_in_session)
        #logto_client.storage |> Map.put(:storage_key_sign_in_session, sign_in_session_json_value)
        storage = %{} |> Map.put(:storage_key_sign_in_session, sign_in_session_json_value)

        IO.inspect storage, label: "session storage for later validation"

        {:ok, sign_in_uri}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def handle_sign_in_callback(request, logto_client) do
    #sign_in_session =
    #  logto_client.storage.get_item(@storage_key_sign_in_session)
    #  |> Poison.decode!(as: %{})
    sign_in_session = %{}

    callback_uri = get_origin_request_url(request)

    IO.inspect callback_uri, label: "callback_uri"

    #
    # (1) - so in essence this gets the full returned url - and ensures we have the right code
    # (2) - then we get the config details to get token endpoint
    # (3) - then we need the code_verifier - retrieve it from the session
    # (4) - the client_secret (this should not change)
    # (5) - the redirect_uri (this should not change)

    # => this gives us the "code_token_response" ([access_token, scope & expire_in])

    #
    # finally we verify and save this.. where ?
    #

    with {:ok, code} <- #(1)
           Core.verify_and_parse_code_from_callback_uri(
             callback_uri,
             sign_in_session.redirect_uri,
             sign_in_session.state
           ),
         {:ok, oidc_config} <- fetch_oidc_config(logto_client), # (2)
         {:ok, code_token_response} <-
           Core.fetch_token_by_authorization_code(logto_client.http_client, %{
             token_endpoint: oidc_config.token_endpoint,
             code: code,
             code_verifier: sign_in_session.code_verifier, #(3) - we need the code_verifier from the session - this was used to generate the code
             client_id: logto_client.logto_config.app_id,
             client_secret: logto_client.logto_config.app_secret,
             redirect_uri: sign_in_session.redirect_uri
           }),
         :ok <- logto_client.storage.set_item(@storage_key_sign_in_session, "") do
      #access_token = %AccessToken{
      access_token = %{
        token: code_token_response.access_token,
        scope: code_token_response.scope,
        expires_at: :os.system_time(:seconds) + code_token_response.expire_in
      }

      access_token_key = build_access_token_key([], "", "")

      verify_and_save_token_response(
        logto_client,
        code_token_response.id_token,
        code_token_response.refresh_token,
        access_token_key,
        access_token,
        oidc_config
      )
    else
      error -> error
    end
  end

  defp fetch_oidc_config(logto_client) do
    # Implement the logic to fetch the OIDC configuration
    # ...
  end

  defp build_access_token_key(scopes, user_id, client_id) do
    # Implement the logic to build the access token key
    # ...
  end

  defp verify_and_save_token_response(
         logto_client,
         id_token,
         refresh_token,
         access_token_key,
         access_token,
         oidc_config
       ) do
    # Implement the logic to verify and save the token response
    # ...
  end
end
