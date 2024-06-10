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
    symbols = '0123456789abcdef'
    symbol_count = Enum.count(symbols)
    for _ <- 1..64, into: "", do: <<Enum.at(symbols, :crypto.rand_uniform(0, symbol_count))>>
  end

  def generate_code_verifier_v2 do
    @base
    |> :crypto.strong_rand_bytes()
    |> Base.encode64(padding: false)
  end
end
