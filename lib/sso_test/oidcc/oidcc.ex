
defmodule SsoTest.Oidcc do
  @moduledoc """
  """

  #def client(session_key) do
  #  %{logto_config: logto_config(), session: %{session: session_key}}
  #end

  @doc """
    here the redirect_url should be the callback url in our app..
  """
  def sign_in() do
    SsoTest.Oidcc.Client.sign_in(%LogtoClient{}, "http://lvh.me:4000/sso/callback")
  end

  #------ private functions -------#

  #defp logto_config do
  #  %{
  #    endpoint: "http://localhost:3001",
  #    app_id: "2a2yi37r08mv2ujr0dhf8",
  #    app_secret: "qPl7Oc8Dxi1VGDDJwYpKjlL7WX99Xemj"
  #  }
  #end
end
