defmodule Shop.Catalog.Product do
  use Ash.Resource,
    otp_app: :shop,
    domain: Shop.Catalog,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "products"
    repo Shop.Repo
  end

  actions do
    defaults [:read, :destroy, update: :*]

    create :create do
      primary? true
      accept [:name, :slug, :description, :price]
      change Shop.Utils.UpsertSlugChange
    end

    update :publish do
      accept []
      change set_attribute(:published_at, NaiveDateTime.utc_now())
    end

    update :unpublish do
      accept []
      change set_attribute(:published_at, nil)
    end
  end

  policies do
    policy always() do
      forbid_if Shop.Checks.Deactivated
      authorize_if Shop.Checks.IsSuperAdmin
    end

    policy_group actor_attribute_equals(:role, :agent) do
      policy action_type([:create, :read, :update]) do
        authorize_if always()
      end
    end

    policy action_type(:read) do
      authorize_if always()
    end
  end

  validations do
    validate present(:name)
    validate string_length(:name, min: 2, max: 100)

    validate match(:slug, ~r/^[A-z0-9-_]+$/)
    validate string_length(:slug, min: 2, max: 100)
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :slug, :string
    attribute :description, :string
    attribute :price, :money
    attribute :published_at, :naive_datetime
    timestamps()
  end

  identities do
    identity :unique_slug, [:slug]
  end
end
