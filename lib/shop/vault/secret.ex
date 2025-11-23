defmodule Shop.Vault.Secret do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @schema_prefix "vault"

  schema "secrets" do
    # This field is automatically encrypted/decrypted on read/write
    field :payload, Shop.Vault.Encrypted
    field :content_hash, :binary

    # We only care when it was created
    timestamps(updated_at: false)
  end

  def changeset(secret, attrs) do
    secret
    |> cast(attrs, [:payload, :content_hash])
    |> validate_required([:payload, :content_hash])
  end
end
