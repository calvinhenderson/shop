defmodule Shop.Repo.Migrations.CreateVault do
  use Ecto.Migration

  @prefix "vault"

  def up do
    execute "CREATE SCHEMA IF NOT EXISTS " <> @prefix

    create table(:secrets, primary_key: false, prefix: @prefix) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")

      add :payload, :binary, null: false
      add :content_hash, :binary, null: false

      add :inserted_at, :naive_datetime_usec, default: fragment("now()")
    end

    create unique_index(:secrets, [:content_hash], prefix: @prefix)
  end

  def down do
    execute "DROP SCHEMA " <> @prefix <> " CASCADE"
  end
end
