defmodule Shop.Vault do
  @moduledoc """
  Vault API for encrypted values storage.
  """
  alias Shop.Repo
  alias Shop.Vault.Secret

  @doc """
  Stores a value and returns a UUID token.

  Preserves basic types through JSON serialization.

  ## Examples

      iex> Shop.Vault.store("hello, world")
      {:ok, uuid_id_token}

      iex> Shop.Vault.store(4)
      {:ok, uuid_id_token}
  """
  @spec store(any()) :: {:ok, String.t()} | {:error, Ecto.Changeset.t()}
  def store(value) do
    payload = %{"v" => value}
    content_hash = Shop.Vault.BlindIndex.calculate(payload)

    case Repo.get_by(Secret, content_hash: content_hash) do
      nil ->
        attrs = %{
          payload: payload,
          content_hash: content_hash
        }

        %Secret{}
        |> Secret.changeset(attrs)
        |> Repo.insert()
        |> case do
          {:ok, secret} -> {:ok, secret.id}
          error -> error
        end

      %{id: id} ->
        {:ok, id}
    end
  end

  @doc """
  Retrieves a value given its UUID token.

  ## Examples

      iex> Shop.Vault.retrieve(valid_id)
      {:ok, "hello, world!"}

      iex> Shop.Vault.retrieve(invalid_id)
      {:error, :not_found}
  """
  @spec retrieve(String.t()) :: {:ok, any()} | {:error, :not_found}
  def retrieve(token_id) do
    case Repo.get(Secret, token_id) do
      nil ->
        {:error, :not_found}

      %Secret{payload: %{"v" => value}} ->
        {:ok, value}
    end
  end

  @doc """
  Permanently deletes a secret (Right to be Forgotten).

  ## Examples

      iex> Shop.Vault.delete(valid_uuid_token)
      :ok

      iex> Shop.Vault.delete(invalid_uuid_token)
      :ok
  """
  def delete(token_id) do
    with %Secret{} = secret <- Repo.get(Secret, token_id),
         {:ok, %Secret{}} <- Repo.delete(secret) do
      :ok
    else
      nil -> :ok
      {:error, reason} -> {:error, reason}
    end
  end
end
