defmodule SsoTestWeb.PageController do
  use SsoTestWeb, :controller

  import SsoTest.Oidcc.Generator
  alias SsoTest.{Oidcc, Oidcc.RequestUtils}

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def sign_in(conn, _params) do
    code_verifier = generate_code_verifier()
    code_challenge = generate_code_challenge(code_verifier)
    state = generate_state()

    case Oidcc.sign_in(code_verifier, code_challenge, state) do
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
        |> render(:home, layout: false)
    end
  end

  def callback(conn, %{"state" => _state}) do
    fetched_conn = conn
    |> fetch_session()

    callback_uri = RequestUtils.get_origin_request_url(conn)

    fetched_conn.private.plug_session
    |> Oidcc.handle_signin_callback(callback_uri)
    |> case do
      {:ok, decoded_tokens} ->

        IO.inspect decoded_tokens, label: "decoded tokens"

        conn
        |> put_flash(:info, "user authenticated successfully!")
        |> put_session(:tokens, decoded_tokens)
        |> render(:home, layout: false)

      {:error, message} ->

        IO.inspect message, label: "authentication failed:"

        conn
        |> put_flash(:error, "user authentication failed!")
        |> put_session(:tokens, nil)
        |> render(:home, layout: false)
    end
  end

end
