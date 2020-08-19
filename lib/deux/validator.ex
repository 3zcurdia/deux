defmodule Deux.Validator do
  @moduledoc """
  Validate sources, comparing with the stored local reports
  """
  alias Deux.DataPoints
  alias Deux.Workers.LocalReports

  @doc """
  It validates a given source with a given report and add data point to history
  """
  def validate(%{id: id} = map, report) do
    valid = LocalReports.valid?(id, report)
    timestamp = DateTime.utc_now()

    msg =
      if valid do
        {:ok, :no_incidents}
      else
        {:error, LocalReports.diff(id, report)}
      end

    tuple = {timestamp, msg}

    map
    |> Map.put(:valid, valid)
    |> Map.put(:updated_at, timestamp)
    |> Map.update(:history, %DataPoints{}, &DataPoints.add(&1, tuple))
  end
end
