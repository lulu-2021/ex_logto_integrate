
defmodule SsoTest.Oidcc do
  @moduledoc """

  from GO..

  code_challenge = option.CodeChallenge
  redirect_uri = option.RedirectUri
  state = option.state
  scopes = option.Scopes

  """


  def client(session_key) do
    %{
      logto_config: logto_config(),
      session: %{session: session_key}
    }

  end

  def generate_signin_uri do
    callback_url = "http://lvh.me:4000/sso/callback"

    client_id = "2a2yi37r08mv2ujr0dhf8"
    client_secret = "qPl7Oc8Dxi1VGDDJwYpKjlL7WX99Xemj"
    redirect_uri = ""
    code_challenge = ""
    code_challenge_method = "S256"
    state = ""
    scopes = []
    response_type = "code"
    prompt = "consent"

  end

  @doc """
    here the redirect_url should be the callback url in our app..
    i.e. "http://lvh.me:4000/sso/callback"
    codeVerifier = core.generateCodeVerifier() # GO
    codeChallenge = core.generateCodeChallenge(codeVerifier) # GO
  """
  def sign_in(redirect_url) do
    config = logto_config()
    code_challenge = code_challenge()

  end

  #------ private functions -------#

  defp code_challenge() do
    verifier = code_verifier()

  end

  defp code_verifier do

  end

  defp logto_config do
    %{
      endpoint: "http://localhost:3001",
      app_id: "2a2yi37r08mv2ujr0dhf8",
      app_secret: "qPl7Oc8Dxi1VGDDJwYpKjlL7WX99Xemj"
    }
  end
end
