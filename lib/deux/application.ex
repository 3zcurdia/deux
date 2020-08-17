defmodule Deux.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Deux.Workers.Sources,
      Deux.Workers.LocalReports,
      Deux.Workers.RemoteSupervisor,
      {Registry, [keys: :unique, name: :report_registry]},
      {Phoenix.PubSub, name: Deux.PubSub},
      Deux.Presence
    ]

    opts = [strategy: :one_for_one, name: Deux.Supervisor]
    supervisor = Supervisor.start_link(children, opts)
    load_sources()
    supervisor
  end

  def load_sources() do
    :deux
    |> Application.get_env(:redis, [])
    |> Enum.each(&Deux.Redis.add/1)

    :deux
    |> Application.get_env(:ping, [])
    |> Enum.each(&Deux.Ping.add/1)
  end
end
