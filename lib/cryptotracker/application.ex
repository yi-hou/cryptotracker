defmodule Cryptotracker.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Cryptotracker.Repo, []),
      supervisor(CryptotrackerWeb.Endpoint, []),
      worker(Cryptotracker.PriceUpdater, []),
    ]

    opts = [strategy: :one_for_one, name: Cryptotracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    CryptotrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
