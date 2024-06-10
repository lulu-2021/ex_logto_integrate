defmodule SsoTestWeb.PageController do
  use SsoTestWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def sign_in(conn, _params) do
    {:ok, sign_in_uri} = SsoTest.Oidcc.Client.sign_in("http://lvh.me:4000/page/callback")
    IO.inspect sign_in_uri

    conn
    |> redirect(external: sign_in_uri)
  end

  def callback(conn, %{"state" => state} = params) do

    IO.inspect params, label: "callback params"

    callback_uri = SsoTest.Oidcc.RequestUtils.get_origin_request_url(conn)
    IO.inspect callback_uri, label: "request callback uri"

    redirect_uri = "http://lvh.me:4000/page/callback"

    response = SsoTest.Oidcc.Core.verify_and_parse_code_from_callback_uri(
      callback_uri,
      redirect_uri,
      state
    )

    IO.inspect response

    #handle_sign_in_callback(conn.request, logto_client)

    render(conn, :home, layout: false)
  end

end
