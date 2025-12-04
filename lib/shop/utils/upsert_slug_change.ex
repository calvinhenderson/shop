defmodule Shop.Utils.UpsertSlugChange do
  @moduledoc """
  Provides a change for upserting a url slug.
  """
  use Ash.Resource.Change

  @slug_regex ~r/[^A-z0-9-_]/

  @impl true
  def init(opts) do
    with :ok <- atom_or_nil(opts, :name_attribute),
         :ok <- atom_or_nil(opts, :slug_attribute) do
      {:ok, opts}
    else
      {:error, attribute} ->
        {:error, "attribute #{attribute} must be an atom!"}
    end
  end

  @impl true
  def change(changeset, opts, _context) do
    name_attr = Keyword.get(opts, :name_attribute, :name)
    slug_attr = Keyword.get(opts, :slug_attribute, :slug)

    slug = Ash.Changeset.get_attribute(changeset, slug_attr)

    if slug do
      changeset
    else
      name = Ash.Changeset.get_attribute(changeset, name_attr)

      slug =
        Regex.replace(@slug_regex, name, "_", global: true)
        |> String.downcase()

      Ash.Changeset.change_attribute(changeset, slug_attr, slug)
    end
  end

  defp atom_or_nil(opts, key) do
    if is_atom(opts[key]) or is_nil(opts[key]) do
      :ok
    else
      {:error, key}
    end
  end
end
