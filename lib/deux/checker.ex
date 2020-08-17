defprotocol Deux.Checker do
  @doc """
  Returns the check map for a given Source
  """
  @spec checksums(map) :: map
  def checksums(map)
end
