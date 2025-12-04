defmodule Shop.Catalog do
  use Ash.Domain,
    otp_app: :shop

  resources do
    resource Shop.Catalog.Product
  end
end
