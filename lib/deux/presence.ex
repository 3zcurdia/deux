defmodule Deux.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.
  """
  use Phoenix.Presence,
    otp_app: :integrity_checker,
    pubsub_server: Deux.PubSub
end
