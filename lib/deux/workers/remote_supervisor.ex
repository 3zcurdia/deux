defmodule Deux.Workers.RemoteSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(attrs) do
    DynamicSupervisor.start_child(__MODULE__, {Deux.Workers.RemoteWorker, attrs})
  end
end
