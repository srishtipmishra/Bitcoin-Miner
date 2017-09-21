defmodule BitcoinMiner.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {BitcoinMiner.Server, name: BitcoinMiner.Server}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end