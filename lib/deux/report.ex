defprotocol Deux.Report do
  @doc """
  Protocol to handle report actions for any given format
  """
  @spec diff(any, any) :: {atom, map}
  def diff(local, remote)

  @spec valid?(any, any) :: boolean
  def valid?(local, remote)
end

defimpl Deux.Report, for: Map do
  def diff(local, remote) do
    if valid?(local, remote) do
      {:ok, %{}}
    else
      subs =
        local
        |> Enum.reject(fn {key, value} -> Map.get(remote, key) == value end)
        |> Map.new()
        |> Map.keys()

      adds =
        remote
        |> Enum.reject(fn {key, value} -> Map.get(local, key) == value end)
        |> Map.new()
        |> Map.keys()

      distance = length(adds || subs)
      {:error, %{adds: adds, subs: subs, distance: distance}}
    end
  end

  def valid?(local, remote), do: Map.equal?(local, remote)
end

defimpl Deux.Report, for: BitString do
  alias Deux.Levenshtein

  def diff(local, remote) do
    if valid?(local, remote) do
      {:ok, %{}}
    else
      distance = Levenshtein.distance(local, remote)
      {:error, %{adds: remote, subs: local, distance: distance}}
    end
  end

  def valid?(local, remote), do: local == remote
end

defimpl Deux.Report, for: Atom do
  def diff(local, remote) do
    if valid?(local, remote) do
      {:ok, %{}}
    else
      {:error, %{adds: remote, subs: local, distance: 2}}
    end
  end

  def valid?(local, remote), do: local == remote
end

defimpl Deux.Report, for: Integer do
  def diff(local, remote) do
    if valid?(local, remote) do
      {:ok, %{}}
    else
      {:error, %{adds: remote, subs: local, distance: abs(local - remote)}}
    end
  end

  def valid?(local, remote), do: local == remote
end
