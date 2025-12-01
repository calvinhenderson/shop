defmodule Shop.Accounts do
  use Ash.Domain,
    otp_app: :shop

  resources do
    resource Shop.Accounts.Token
    resource Shop.Accounts.User
  end
end
