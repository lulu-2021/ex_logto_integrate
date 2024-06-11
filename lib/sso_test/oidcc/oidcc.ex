
defmodule SsoTest.Oidcc do
  @moduledoc """

  """
  alias SsoTest.Oidcc.{Core, Client, ClientConfig, RequestUtils, Token}

  @doc """
    here the redirect_url should be the callback url in our app..
  """
  def sign_in(code_verifier, code_challenge, state) do
    ClientConfig.callback_url()
    |> Client.sign_in(code_challenge, code_verifier, state)
    |> case do
      {:ok, sign_in_uri} ->
        {:ok, sign_in_uri}
      {:error, message} ->
        {:error, message}
    end
  end

  def handle_signin_callback(conn, session) do
    code_verifier = get_code_verifier(session)
    callback_uri = RequestUtils.get_origin_request_url(conn)
    code = Core.get_code_from_callback_uri(callback_uri)
    response = ClientConfig.callback_url()
    |> Client.process_callback(code_verifier, code)
    |> case do
      {:ok, token_map} ->
        token_map
        |> decode_claims()
        |> user_info()

      {:error, message} ->
        IO.inspect message, label: "signing callback failed"
    end

    IO.inspect response, label: "client handle signin callback response"
    conn
  end

  #------ private functions -------#
  defp get_code_verifier(%{"code_verifier" => code_verifier}), do: code_verifier

  defp user_info(%{"access_token" => access_token}) do
    access_token
    |> Core.fetch_user_info()
    |> case do
      {:ok, user_info} ->
        IO.inspect user_info, label: "user info"
      {:error, data} ->
        IO.inspect data, label: "user info fetch failed"
    end
  end

  defp decode_claims(%{"id_token" => id_token} = token_map) do
    IO.inspect token_map, label: "token_map"

    response = id_token
    |> Token.decode_id_token()

    IO.inspect response, label: "id token claims"

    token_map
  end
end
