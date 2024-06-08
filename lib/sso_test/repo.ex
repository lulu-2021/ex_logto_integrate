defmodule SsoTest.Repo do
  use Ecto.Repo,
    otp_app: :sso_test,
    adapter: Ecto.Adapters.Postgres
end
