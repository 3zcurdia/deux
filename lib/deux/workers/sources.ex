defmodule Deux.Workers.Sources do
  @moduledoc """
  It stores the redis sources
  """
  require Logger
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def all do
    GenServer.call(__MODULE__, {:all})
  end

  def add(source) do
    GenServer.cast(__MODULE__, {:add, source})
  end

  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  def validate(id, report) do
    GenServer.cast(__MODULE__, {:validate, id, report})
  end

  # Callbacks
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:all}, _from, state) do
    # Logger.debug("#{__MODULE__}#all")
    {:reply, Map.values(state), state}
  end

  @impl true
  def handle_call({:get, id}, _from, state) do
    # Logger.debug("#{__MODULE__}#get #{id}")
    {:reply, Map.get(state, id), state}
  end

  @impl true
  def handle_cast({:add, source}, state) do
    Logger.debug("#{__MODULE__}#add #{source.id}")
    {:noreply, Map.put(state, source.id, source)}
  end

  @impl true
  def handle_cast({:validate, id, report}, state) do
    # Logger.debug("#{__MODULE__}#validate #{id}")
    source =
      state
      |> Map.get(id)
      |> Deux.Validator.validate(report)

    {:noreply, Map.put(state, id, source)}
  end
end
