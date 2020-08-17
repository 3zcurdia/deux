defmodule Deux.Workers.LocalReports do
  @moduledoc """
  It stores local stored reports as source of truth
  """
  require Logger
  use GenServer
  alias Deux.Report
  alias Deux.Checker

  @table_name :local_reports

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def set(%{id: id} = service) do
    GenServer.cast(__MODULE__, {:set, id, service})
  end

  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  def valid?(id, remote) do
    GenServer.call(__MODULE__, {:valid, id, remote})
  end

  # Callbacks
  @impl true
  def init(state) do
    :ets.new(@table_name, [:set, :protected, :named_table])
    {:ok, state}
  end

  @impl true
  def handle_cast({:set, id, service}, state) do
    # Logger.debug("#{__MODULE__}#set #{id}")
    report = Checker.checksums(service)
    :ets.insert(@table_name, {id, report, DateTime.utc_now()})
    {:noreply, [id | state]}
  end

  @impl true
  def handle_call({:get, id}, _from, state) do
    # Logger.debug("#{__MODULE__}#get #{id}")

    case lookup(id) do
      {:ok, result} ->
        {:reply, result, state}

      {:error, msg} ->
        Logger.error("#{__MODULE__} #{msg}")
        {:reply, [], state}
    end
  end

  @impl true
  def handle_call({:valid, id, remote}, _from, state) do
    # Logger.debug("#{__MODULE__}#valid #{id}")

    case lookup(id) do
      {:ok, local} -> {:reply, Report.valid?(local, remote), state}
      {:error, _msg} -> {:reply, false, state}
    end
  end

  defp lookup(id) do
    case :ets.lookup(@table_name, id) do
      [{_report_id, result, _timestamp}] -> {:ok, result}
      _ -> {:error, "ID(#{id}) Not found"}
    end
  end
end
