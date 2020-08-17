defmodule Deux.Redis do
  @moduledoc """
  Handle the redis sources and services integirty checks
  """
  alias Deux.Redis.Source
  alias Deux.Workers.{Sources, LocalReports, RemoteSupervisor}

  @doc """
  Adds the remote redis source, load local reports and start worker

  ## Params

  - name: the name of the given source
  - url: the url from the redis service to connect
  - filters: a list of values you want to monitor via regex or strings
    - regex: fetch all keys and filter programaticly with reges
    - string: redis string filters

  ## Examples

      iex> srv = Deux.Redis.add(name: "localhost", url: "redis://127.0.0.1:6379", filters: [%{filter: "flag:*"}])
      iex> srv = Deux.Redis.add(name: "localhost", url: "redis://127.0.0.1:6379", filters: [%{regex: ~r/flag.*/}])
  """
  def add(args) when is_nil(args), do: nil
  def add(args) when is_list(args), do: args |> Map.new() |> add

  def add(args) do
    args
    |> Source.build()
    |> Deux.find_or_add_source()
  end
end
