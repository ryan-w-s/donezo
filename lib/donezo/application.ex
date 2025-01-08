defmodule Donezo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DonezoWeb.Telemetry,
      Donezo.Repo,
      {DNSCluster, query: Application.get_env(:donezo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Donezo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Donezo.Finch},
      # Start a worker by calling: Donezo.Worker.start_link(arg)
      # {Donezo.Worker, arg},
      # Start to serve requests, typically the last entry
      DonezoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Donezo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DonezoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
