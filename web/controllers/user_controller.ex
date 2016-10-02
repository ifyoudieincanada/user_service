defmodule UserService.UserController do
  use UserService.Web, :controller

  alias UserService.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    changeset = if Repo.one(User) == nil do
      admin = %UserService.Permission{
        name: "admin",
        description: "In control of literally everything"
      }

      Ecto.Changeset.put_assoc(changeset, :permissions, [admin])
    else
      changeset
    end

    case Repo.insert(changeset) do
      {:ok, user} ->
        EventClient.send_event("user.create", %{"user_id" => user.id})

        conn = conn
               |> put_status(:created)
               |> put_resp_header("location", user_path(conn, :show, user))

        token = Phoenix.Token.sign(UserService.Endpoint, "user", user.id)

        conn
        |> render("user.json", %{user: user, token: token})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UserService.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def login(conn, %{"user" => user_params}) do
    changeset = User.login_changeset(%User{}, user_params)

    if changeset.valid? do
      id = Ecto.Changeset.get_field(changeset, :id)
      token = Phoenix.Token.sign(UserService.Endpoint, "user", id)

      render(conn, "user.json", %{token: token, user: Repo.get!(User, id)})
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(UserService.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def verify(conn, %{"token" => token}) do
    token = :base64.decode(token)

    case Phoenix.Token.verify(UserService.Endpoint, "user", token) do
      {:ok, user_id} ->
        render(conn, "user.json", user: Repo.get!(User, user_id), token: token)
      {:error, _} ->
        send_401(conn)
    end
  end

  def show(conn, %{"id" => id, "permission" => permission_name}) do
    user = Repo.get!(User, id)

    permission = Enum.find(user.permissions, fn permission ->
      permission.name == permission_name
    end)

    render(conn, "bool.json", bool: permission != nil)
  end

  def update(conn, %{"id" => id, "user" => user_params, "token" => token}) do
    :base64.decode(token)

    case verify_user(token, id) do
      {:ok, id} ->
        user = Repo.get!(User, id)
        changeset = User.changeset(user, user_params)

        case Repo.update(changeset) do
          {:ok, user} ->
            render(conn, "show.json", user: user)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(UserService.ChangesetView, "error.json", changeset: changeset)
        end
      {:error, _} ->
        send_401(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    token = get_req_header(conn, "token")
            |> :base64.decode

    case verify_user(token, id) do
      {:ok, id} ->
        user = Repo.get!(User, id)

        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(user)

        send_resp(conn, :no_content, "")
      {:error, _} ->
        send_401(conn)
    end
  end

  defp verify_user(token, id) do
    with {:ok, user_id} <- Phoenix.Token.verify(UserService.Endpoint, "user", token) do
      case user_id do
        ^id ->
           {:ok, id}
         _ ->
           {:error, :invalid}
      end
    end
  end

  defp send_401(conn) do
    send_resp(conn, 401, "{errors:[\"unauthorized\"]}")
  end
end
