defmodule Shop.VaultTest do
  use Shop.DataCase

  alias Shop.Vault

  describe "store/1" do
    test "stores an encrypted secret" do
      plain_text = "plain text"

      assert {:ok, _plain_text_token} = Vault.store(plain_text)
    end

    test "stores valid json" do
      object = %{
        "array" => [1, 2, 3],
        "boolean" => 4,
        "nested" => %{"now" => DateTime.utc_now() |> DateTime.to_iso8601()}
      }

      assert {:ok, _object_token} = Vault.store(object)
    end

    test "deduplicates when storing" do
      plain_text = "plain_text"

      assert {:ok, token_1} = Vault.store(plain_text)
      assert {:ok, token_2} = Vault.store(plain_text)

      assert token_1 == token_2
    end
  end

  describe "retrieve/1" do
    test "retrieves a stored secret" do
      plain_text = "plain text"

      assert {:ok, plain_text_token} = Vault.store(plain_text)
      assert {:ok, retrieved_value} = Vault.retrieve(plain_text_token)

      assert plain_text == retrieved_value
    end

    test "retrieves valid json" do
      object = %{
        "array" => [1, 2, 3],
        "boolean" => 4,
        "nested" => %{"now" => DateTime.utc_now() |> DateTime.to_iso8601()}
      }

      assert {:ok, object_token} = Vault.store(object)
      assert {:ok, retrieved_object} = Vault.retrieve(object_token)

      assert Map.equal?(object, retrieved_object)
    end
  end

  describe "delete/1" do
    test "deletes a stored secret" do
      plain_text = "plain text"

      assert {:ok, plain_text_token} = Vault.store(plain_text)
      assert :ok = Vault.delete(plain_text_token)
    end

    test "returns :ok for invalid tokens" do
      invalid_token = "00000000-0000-0000-0000-000000000000"

      assert :ok = Vault.delete(invalid_token)
    end
  end
end
