defmodule ShopWeb.AshTypescriptRpcController do
  use ShopWeb, :controller

  def run(conn, params) do
    result = AshTypescript.Rpc.run_action(:shop, conn, params)
    json(conn, result)
  end

  def validate(conn, params) do
    result = AshTypescript.Rpc.validate_action(:shop, conn, params)
    json(conn, result)
  end
end
