defmodule SsoTest.Oidcc.Generator do
  @moduledoc """
    some random number, base64 encoding helper functions
  """
  @base 64

  @doc """
    generate the code challenge
  """
  def generate_code_challenge(code_verifier) do
    :sha256
    |> :crypto.hash(code_verifier)
    |> Base.url_encode64(padding: false)
  end

  @doc """
    generate the "state" for the session
  """
  def generate_state, do: generate_code_verifier()

  def generate_code_verifier do
    @base
    |> :crypto.strong_rand_bytes()
    |> Base.encode64(padding: false)
  end
end
