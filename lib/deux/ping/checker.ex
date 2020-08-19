defimpl Deux.Checker, for: Deux.Ping.Source do
  alias Deux.Crypto

  def checksums(%{mode: mode, request: request}) do
    request
    |> Tesla.request()
    |> check(mode)
  end

  def check({:ok, %{status: status}}, :status), do: Enum.member?(200..299, status)
  def check({:ok, %{body: body}}, :body), do: Crypto.sha2(body)
  def check({:ok, %{body: body}}, :json), do: Jason.decode!(body)
end
