defmodule UserService.UserController do
  use UserService.Web, :controller

  alias UserService.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn = conn
               |> put_status(:created)
               |> put_resp_header("location", user_path(conn, :show, user))

        token = Phoenix.Token.sign(UserService.Endpoint, "user", user.id)

        conn
        |> render("show.json", user: user, token: token)
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

      render(conn, "user.json", token: token, user: Repo.get!(User, id))
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(UserService.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def verify(conn, %{"token" => token}) do
    case Phoenix.Token.verify(UserService.Endpoint, "user", token) do
      {:ok, user_id} ->
        render(conn, "user.json", user: Repo.get!(User, user_id), token: token)
      {:error, _} ->
        conn
        |> put_status(401)
        |> render("401.json")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
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
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
