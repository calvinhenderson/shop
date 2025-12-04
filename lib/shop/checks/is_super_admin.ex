defmodule Shop.Checks.IsSuperAdmin do
  @moduledoc """
  Policy to check if an actor is a super admin.
  """

  use Ash.Policy.SimpleCheck

  def describe(_) do
    "actor is a super admin"
  end

  def match?(%Shop.Accounts.User{role: role} = _actor, _context, _opts) do
    role == :admin
  end

  def match?(_, _, _), do: false
end
