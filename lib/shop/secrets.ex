defmodule Shop.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Shop.Accounts.User, _opts, _context) do
    Application.fetch_env(:shop, :token_signing_secret)
  end
end
