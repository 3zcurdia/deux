defmodule Deux.Workers.RemoteWorker do
  @moduledoc """
  It Fetchs reids source and checks integirty
  """
  require Logger

  use GenServer
  alias Deux.Checker
  alias Deux.Workers.Sources

  def start_link(%{id: id}) do
    GenServer.start_link(__MODULE__, %{id: id}, name: via_tuple(id))
  end

  def get(server_id) do
    GenServer.call(via_tuple(server_id), {:get})
  end

  # Callbacks
  @impl true
  def init(state) do
    Logger.debug("#{__MODULE__}#init #{state.id}")
    {:ok, state, {:continue, {:load_report}}}
  end

  @impl true
  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_continue({:load_report}, %{id: id} = state) do
    # Logger.debug("#{__MODULE__}#load_report #{id}")
    updated_state = Map.merge(state, %{report: fetch_report(id)})
    schedule_refresh()
    {:noreply, updated_state, {:continue, {:update_validity}}}
  end

  @impl true
  def handle_continue({:update_validity}, %{id: id, report: report} = state) do
    # Logger.debug("#{__MODULE__}#update_validity #{id}")
    Sources.validate(id, report)
    Deux.broadcast_report(:report_updated, id)
    {:noreply, state}
  end

  @impl true
  def handle_info({:update_report}, state) do
    Logger.debug("#{__MODULE__}#update_report")
    {:noreply, state, {:continue, {:load_report}}}
  end

  defp schedule_refresh do
    Process.send_after(self(), {:update_report}, 300_000)
  end

  defp fetch_report(id) do
    id |> Sources.get() |> Checker.checksums()
  end

  defp via_tuple(server_id) do
    {:via, Registry, {:report_registry, server_id}}
  end
end
