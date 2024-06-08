defmodule SsoTest.Oidcc.Generator do
  @moduledoc """
    some random number, base64 encoding helper functions
  """
  @base 64

  @doc """
    generate the code challenge
  """
  def generate_code_challenge() do
    code_verifier = generate_code_verifier()

    :sha256
    |> :crypto.hash(code_verifier)
    |> Base.url_encode64(padding: false)
  end

  @doc """
    generate the "state" for the session
  """
  def generate_state, do: generate_code_verifier()

  # ------ private functions ------ #
  defp generate_code_verifier do
    @base
    |> :crypto.strong_rand_bytes()
    |> Base.encode64(padding: false)
  end
end
