defmodule Deux.Redis.Source do
  alias Deux.{Crypto, DataPoints}
  defstruct [
    :id,
    :name,
    :url,
    :client,
    :filters,
    :inserted_at,
    :updated_at,
    valid: false,
    type: "redis",
    history: %DataPoints{}
  ]

  def build(%{url: url} = args) do
    name = Map.get(args, :name, "")
    filters = build_filters(args[:filters])
    client = Exredis.start_using_connection_string(url)

    %Deux.Redis.Source{
      id: Crypto.sha(url),
      name: name,
      url: url,
      client: client,
      filters: filters,
      inserted_at: DateTime.utc_now()
    }
  end

  defp build_filters(filter) when is_nil(filter), do: [%{filter: "*"}]
  defp build_filters(filter), do: filter
end
