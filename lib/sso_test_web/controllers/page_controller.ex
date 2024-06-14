defmodule SsoTestWeb.PageController do
  @moduledoc """
  """
  use SsoTestWeb, :controller

  def home(conn, _params) do
    authenticated = conn
    |> ExLogto.authenticated?()

    render(conn, :home, layout: false, authenticated: authenticated)
  end

  def sign_in(conn, _params) do
    code_verifier = ExLogto.code_verifier()
    code_challenge = ExLogto.code_challenge(code_verifier)
    state = ExLogto.state()

    case ExLogto.sign_in(code_verifier, code_challenge, state) do
      {:ok, sign_in_uri} ->
        conn
        |> fetch_session()
        |> put_session(:code_verifier, code_verifier)
        |> put_session(:code_challenge, code_challenge)
        |> put_session(:state, state)
        |> redirect(external: sign_in_uri)

      {:error, _message} ->
        conn
        |> put_flash(:error, "Signin request failed!")
        |> render(:home, layout: false, authenticated: true)
    end
  end

  def callback(conn, %{"state" => _state}) do
    fetched_conn = conn
    |> fetch_session()

    callback_uri = ExLogto.get_origin_request_url(conn)

    fetched_conn.private.plug_session
    |> ExLogto.handle_signin_callback(callback_uri)
    |> case do
      {:ok, decoded_tokens} ->

        IO.inspect decoded_tokens, label: "decoded tokens"

        conn
        |> put_flash(:info, "user authenticated successfully!")
        |> put_session(:tokens, decoded_tokens)
        |> render(:home, layout: false, authenticated: true)

      {:error, error} ->

        conn
        |> put_flash(:error, "user authentication failed #{inspect error}!")
        |> put_session(:tokens, nil)
        |> render(:home, layout: false, authenticated: false)
    end
  end

  def refresh_token(conn, _params) do
    fetched_conn = conn
    |> fetch_session()

    session_tokens = fetched_conn.private.plug_session
    |> session_tokens()

    session_tokens.refresh_token
    |> ExLogto.refresh_token()
    |> case do
      {:ok, tokens} ->
        IO.inspect tokens, label: "refreshed tokens"

        authenticated = conn
        |> ExLogto.authenticated?()

        conn
        |> put_flash(:info, "User token refreshed successfully!")
        |> render(:home, layout: false, authenticated: authenticated)

      {:error, error} ->

        conn
        |> put_flash(:error, "Token refresh failed: #{inspect error}")
        |> put_session(:tokens, nil)
        |> render(:home, layout: false, authenticated: false)
    end
  end

  def end_session(conn, _params) do
    case ExLogto.sign_out() do
      {:ok, logout_url} ->

        IO.inspect logout_url, label: "logout url"

        conn
        |> put_session(:tokens, nil)
        |> redirect(external: logout_url)

      {:error, error} ->
        conn
        |> put_flash(:info, "Logout uri generation failed #{inspect error}")
        |> put_session(:tokens, nil)
        |> render(:home, layout: false, authenticated: false)
    end
  end

  defp session_tokens(%{"tokens" => tokens}), do: tokens
end
