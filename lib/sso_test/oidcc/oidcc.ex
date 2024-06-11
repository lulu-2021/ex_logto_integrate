
defmodule SsoTest.Oidcc do
  @moduledoc """

  """
  alias SsoTest.Oidcc.{Core, Client, ClientConfig, RequestUtils}

  @doc """
    here the redirect_url should be the callback url in our app..
  """
  def sign_in(code_verifier, code_challenge, state) do
    case Client.sign_in(@callback_url, code_challenge, code_verifier, state) do
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

    IO.inspect response, label: "client handle signin callback response"
    conn
  end

  #------ private functions -------#
  defp get_code_verifier(%{"code_verifier" => code_verifier}), do: code_verifier

end
