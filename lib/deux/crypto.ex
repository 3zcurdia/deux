defmodule Deux.Crypto do
  @moduledoc """
  Facade of Crypto erlang module
  """

  def sha(value), do: :crypto.hash(:sha, value) |> Base.encode16()
  def sha2(value), do: :crypto.hash(:sha256, value) |> Base.encode16()
  # def sha512(value), do: :crypto.hash(:sha512, value) |> Base.encode16()
end
