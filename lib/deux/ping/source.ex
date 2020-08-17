defmodule Deux.Ping.Source do
  alias Deux.{Crypto, DataPoints}
  defstruct [
    :id,
    :name,
    :request,
    :mode,
    :inserted_at,
    :updated_at,
    valid: false,
    type: "ping",
    history: %DataPoints{}
  ]


  def build(%{request: request} = args) do
    mode = Map.get(args, :mode, :status)

    %Deux.Ping.Source{
      id: id_for(request, mode),
      name: Map.get(args, :name, "default"),
      request: request,
      mode: mode,
      inserted_at: DateTime.utc_now()
    }
  end

  defp id_for(request, mode) do
    {:method, method} = List.keyfind(request, :method, 0, :get)
    {:url, url} = List.keyfind(request, :url, 0, "")
    {:headers, headers} = List.keyfind(request, :headers, 0, [])

    headers_string =
      headers
      |> Enum.map(fn tuple -> tuple |> Tuple.to_list() |> Enum.join() end)
      |> Enum.join()

    "#{Atom.to_string(method)}::#{Atom.to_string(mode)}::#{url}::#{headers_string}" |> Crypto.sha()
  end
end
