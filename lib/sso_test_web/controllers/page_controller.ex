defmodule SsoTestWeb.PageController do
  use SsoTestWeb, :controller

  @callback_url "http://lvh.me:4000/page/callback"
  import SsoTest.Oidcc.Generator

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def sign_in(conn, _params) do
    code_verifier = generate_code_verifier()
    code_challenge = generate_code_challenge(code_verifier)
    state = generate_state()

    {:ok, sign_in_uri} = SsoTest.Oidcc.Client.sign_in(@callback_url, code_challenge, code_verifier, state)
    #IO.inspect sign_in_uri

    conn
    |> fetch_session()
    |> put_session(:code_verifier, code_verifier)
    |> put_session(:code_challenge, code_challenge)
    |> put_session(:state, state)
    |> redirect(external: sign_in_uri)
  end

  def callback(conn, %{"state" => state} = params) do

    fetched_conn = conn
    |> fetch_session()

    session = fetched_conn.private.plug_session
    #IO.inspect session, label: "session"
    #IO.inspect params, label: "callback params"

    callback_uri = SsoTest.Oidcc.RequestUtils.get_origin_request_url(conn)
    IO.inspect callback_uri, label: "request callback uri"

    code = SsoTest.Oidcc.Core.get_code_from_callback_uri(callback_uri)
    IO.inspect code, label: ">>> code"

    #handle_sign_in_callback(conn.request, logto_client)

    #
    # need to get the code from the response
    #
    code_verifier = get_code_verifier(session)
    SsoTest.Oidcc.Client.process_callback(conn, @callback_url, code_verifier, code)

    render(conn, :home, layout: false)
  end

  defp get_code_challenge(%{"code_challenge" => code_challenge}), do: code_challenge
  defp get_code_verifier(%{"code_verifier" => code_verifier}), do: code_verifier
  defp get_state(%{"state" => state}), do: state
end
