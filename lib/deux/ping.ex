defmodule Deux.Ping do
  @moduledoc """
  Handle the ping sources and services integirty checks
  """
  alias Deux.Ping.Source

  @doc """
  Adds the remote ping source, load local reports and start worker

  ## Params

    - name: the name of the given source
    - request: tesla request tuple list
    - mode: (default :status) to monitor mode
       - `:status`: it monitors succesful statuses
       - `:body`: it monitors the complete body from a response
       - `:json`: it monitors the json reponse

  ## Examples

      iex> srv = Deux.Ping.add(name: "localhost", request: [method: :get, url: "http://127.0.0.1:3000"], mode: :body)
  """

  def add(args) when is_nil(args), do: nil
  def add(args) when is_list(args), do: args |> Map.new() |> add

  def add(args) do
    args
    |> Source.build()
    |> Deux.find_or_add_source()
  end
end
