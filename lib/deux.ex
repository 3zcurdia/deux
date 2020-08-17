defmodule Deux do
  @moduledoc """
  It monitors all services to get an integrity report.
  """
  alias Deux.Workers.{Sources, LocalReports, RemoteSupervisor}

  @topic "reports"

  @doc """
  It subscribes to the PubSub reports channel
  """
  def subscribe do
    Phoenix.PubSub.subscribe(Deux.PubSub, @topic)
  end

  @doc """
  It broadcast the event for a given report
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
