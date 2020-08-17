defimpl Deux.Checker, for: Deux.Redis.Source do
  alias Exredis.Api
  alias Deux.Crypto

  def checksums(%{client: client, filters: filters}) do
    filters
    |> Stream.map(fn filter -> check(client, filter) end)
    |> Enum.reduce(%{}, fn check_map, acc -> Map.merge(acc, check_map) end)
  end

  @doc """
  Returns the checksum for each key in redis client. The default response will evaluate all keys,
  you can avoid that by passing the filtering options:

  - *filter*: string redis filter
  - *regex*: regular expression filter, this method will fetch all keys and then filter programmatically

  ## Example

      iex> {:ok, client} = Exredis.start_link
      iex> client |> Deux.Redis.Checker.check
      %{
        "flag:on" => "8032B3DEF5C749E3A5054D66D22374EBA304A06C2134ADCFDF18DBA139F2B613",
        "queues" => "8455CDF647FDE35F3ECADFF9C396ED0CDFD51B57D9C453041756F5BBBE9FA1D5",
        "flag:test" => "5DEFE8E5BE10DB68D41BED533EC567DA1C8BD3D8ADE0B2FCF2F5967959F3D592"
      }

      iex> client |> Deux.RedisChecker.check(filter: "flag:*")
      %{
        "flag:on" => "8032B3DEF5C749E3A5054D66D22374EBA304A06C2134ADCFDF18DBA139F2B613",
        "flag:test" => "5DEFE8E5BE10DB68D41BED533EC567DA1C8BD3D8ADE0B2FCF2F5967959F3D592"
      }

      iex> client |> Deux.RedisChecker.check(regex: ~r/flag.*/)
      %{
        "flag:on" => "8032B3DEF5C749E3A5054D66D22374EBA304A06C2134ADCFDF18DBA139F2B613",
        "flag:test" => "5DEFE8E5BE10DB68D41BED533EC567DA1C8BD3D8ADE0B2FCF2F5967959F3D592"
      }
  """
  @spec check(pid) :: map
  def check(client), do: check(client, filter: "*")

  @spec check(pid, map) :: map
  def check(client, opts) do
    client
    |> fetch(opts)
    |> Task.async_stream(&key_check(client, &1), max_concurrency: max_concurrency())
    |> Stream.filter(fn {:ok, _value} -> true end)
    |> Stream.map(fn {:ok, value} -> value end)
    |> Enum.reduce(%{}, fn {key, value}, acc -> Map.put(acc, key, value) end)
  end

  defp fetch(client, %{filter: filter}), do: fetch(client, filter: filter)

  defp fetch(client, filter: filter) do
    client |> Api.keys(filter)
  end

  defp fetch(client, %{regex: regex}), do: fetch(client, regex: regex)

  defp fetch(client, regex: regex) do
    client
    |> Api.keys("*")
    |> Stream.filter(fn str -> Regex.match?(regex, str) end)
  end

  defp fetch(_client, _opts), do: []

  defp key_check(client, key) do
    {key, Crypto.sha2(Api.get(client, key))}
  end

  defp max_concurrency do
    case :erlang.system_info(:logical_processors_online) do
      :unknown -> 2
      value -> value
    end
  end
end
