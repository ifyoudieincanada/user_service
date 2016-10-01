defmodule UserService.User do
  use UserService.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_tmp, :string, virtual: true
    field :password, :string

    timestamps()
  end

  def by_username(query, username) do
    from q in query,
      where: q.username == ^username
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password_tmp])
    |> validate_required([:username, :email, :password_tmp])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password
  end

  def login_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password_tmp])
    |> validate_required([:username, :password_tmp])
    |> validate_user
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
    hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password_tmp))
    Ecto.Changeset.put_change(changeset, :password, hashedpw)
  end

  defp validate_user(%{valid?: false} = changeset), do: changeset
  defp validate_user(%{valid?: true} = changeset) do
    password = Ecto.Changeset.get_field(changeset, :password_tmp)
    username = Ecto.Changeset.get_field(changeset, :username)

    user = %__MODULE__{}
           |> by_username(username)
           |> UserService.Repo.one

    if Comeonin.Bcrypt.checkpw(password, user.password) do
      changeset
    else
      Ecto.Changeset.add_error(changeset, :password_tmp, "Password is incorrect")
    end
  end
end
