defmodule SsoTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SsoTestWeb.Telemetry,
      SsoTest.Repo,
      {DNSCluster, query: Application.get_env(:sso_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SsoTest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SsoTest.Finch},
      # Start a worker by calling: SsoTest.Worker.start_link(arg)
      # {SsoTest.Worker, arg},

      # Start to serve requests, typically the last entry
      SsoTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SsoTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SsoTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
