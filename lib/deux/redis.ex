defmodule Deux.Redis do
  @moduledoc """
  Handle the redis sources and services integirty checks
  """
  alias Deux.Redis.Source
  alias Deux.Workers.{Sources, LocalReports, RemoteSupervisor}

  @doc """
  It sets the remote server in sources, local reports and worker

  ## Examples

      iex> srv = Deux.Redis.add(%{"name" => "localhost", "url" => "redis://127.0.0.1:6379"})
  """
  def add(args) when is_nil(args), do: nil

  def add(args) do
    args
    |> Source.build()
    |> Deux.find_or_add_source()
  end
end
