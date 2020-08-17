defmodule Deux.Ping do
  @moduledoc """
  Handle the redis sources and services integirty checks
  """
  alias Deux.Ping.Source

  @doc """
  Adds the remote ping source, load local reports and start worker

  ## Params

    - name: the name of the given source
    - request: the url from the redis service to connect
    - mode: (default :status) to monitor mode
       - `:status`: it monitors succesful statuses
       - `:body`: it monitors the complete body from a response

  ## Examples

      iex> srv = Deux.Ping.add(name: "localhost", url: "http://127.0.0.1:3000", mode: :body)
  """

  def add(args) when is_nil(args), do: nil
  def add(args) when is_list(args), do: args |> Map.new() |> add

  def add(args) do
    args
    |> Source.build()
    |> Deux.find_or_add_source()
  end
end
