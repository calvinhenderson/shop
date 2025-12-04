defmodule Shop.Checks.Deactivated do
  @moduledoc """
  Policy to check if an actor is deactivated.
  """

  use Ash.Policy.SimpleCheck

  def describe(_) do
    "actor is deactivated"
  end

  def match?(%Shop.Accounts.User{archived_at: archived_at} = _actor, _context, _opts) do
    not is_nil(archived_at)
  end

  def match?(_, _, _), do: false
end
