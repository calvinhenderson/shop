defmodule Shop.Vault.BlindIndex do
  @moduledoc """
  Generates a deterministic hash for encrypted data queries.
  """

  def calculate(payload) do
    encoded = Jason.encode!(payload)
    :crypto.mac(:hmac, algorithm(), secret(), encoded)
  end

  defp algorithm, do: Application.fetch_env!(:shop, __MODULE__)[:algorithm]
  defp secret, do: Application.fetch_env!(:shop, __MODULE__)[:secret]
end
