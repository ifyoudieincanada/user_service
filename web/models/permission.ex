defmodule UserService.Permission do
  use UserService.Web, :model

  schema "permissions" do
    field :name, :string
    field :description, :string
    belongs_to :user, UserService.User

    timestamps()
  end

  def is_admin(query, user_id) do
    from q in query,
      where: q.user_id == ^user_id
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :user_id])
    |> validate_required([:name, :description, :user_id])
  end
end
