defmodule Deux.Ping do
  @moduledoc """
  Handle the redis sources and services integirty checks
  """
  alias Deux.Ping.Source

  def add(args) when is_nil(args), do: nil

  def add(args) do
      args
      |> Source.build()
      |> Deux.find_or_add_source()
  end
end
