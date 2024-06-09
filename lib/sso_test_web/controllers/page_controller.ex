defmodule SsoTestWeb.PageController do
  use SsoTestWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def callback(conn, params) do
    IO.inspect params, label: "callback params"

    conn
    |> redirect(to: "/")
  end
end
