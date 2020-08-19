defmodule Deux do
  @moduledoc """
  Status monitor for external services
  """
  alias Deux.Workers.{Sources, LocalReports, RemoteSupervisor, RemoteWorker}

  @topic "reports"

  @doc """
  It subscribes to the PubSub reports channel

  ## Examples

     iex> Deux.subscribe()
  """
  def subscribe do
    Phoenix.PubSub.subscribe(Deux.PubSub, @topic)
  end

  @doc """
  It broadcast the event for a given report

  ## Examples

     ex> Deux.broadcast_report(:update_report, "12452465645352413")
  """
  def broadcast_report(event, id) do
    Phoenix.PubSub.broadcast(Deux.PubSub, @topic, {event, id})
  end

  @doc """
  Returns and array of all sources
  """
  def list_sources, do: {:ok, Sources.all()}

  @doc """
  Returns a given source
  """
  def get_source(%{id: id}), do: get_source(id)

  def get_source(id) do
    source = Sources.get(id)

    if is_nil(source) do
      {:error, :not_found}
    else
      {:ok, source}
    end
  end

  def get_local_report(%{id: id}), do: get_local_report(id)
  def get_local_report(id), do: LocalReports.get(id)

  def get_remote_report(%{id: id}), do: get_remote_report(id)
  def get_remote_report(id), do: RemoteWorker.get(id)

  def find_or_add_source(source) do
    if report_exists?(source) do
      get_source(source)
    else
      Sources.add(source)
      LocalReports.set(source)
      RemoteSupervisor.start_child(source)
      source
    end
  end

  defp report_exists?(%{id: id}) do
    :report_registry
    |> Registry.lookup(id)
    |> Enum.any?()
  end
end
