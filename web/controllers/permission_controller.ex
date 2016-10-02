defmodule UserService.PermissionController do
  use UserService.Web, :controller

  alias UserService.Permission

  def index(conn, _params) do
    permissions = Repo.all(Permission)
    render(conn, "index.json", permissions: permissions)
  end

  def create(conn, %{"permission" => permission_params,
                     "user_id" => user_id,
                     "token" => token}) do

    token = :base64.decode(token)
    case ensure_admin(token) do
      {:ok, _} ->
        params = Map.put(permission_params, :user_id, user_id)
        changeset = Permission.changeset(%Permission{}, params)

        case Repo.insert(changeset) do
          {:ok, permission} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", permission_path(conn, :show, permission))
            |> render("show.json", permission: permission)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(UserService.ChangesetView, "error.json", changeset: changeset)
        end
      {:error, _} ->
        conn
        |> send_401
    end
  end

  def delete(conn, %{"id" => id, "token" => token}) do
    token = :base64.decode(token)
    case ensure_admin(token) do
      {:ok, _} ->
        permission = Repo.get!(Permission, id)

        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(permission)

        send_resp(conn, :no_content, "")
      {:error, _} ->
        conn
        |> send_401
    end
  end

  defp ensure_admin(token) do
    with {:ok, user_id} <-  verify_user(token) do
      permission = Permission
                   |> Permission.is_admin(user_id)
                   |> Repo.one

      case permission do
        nil ->
          {:error, 401}
        _ ->
          {:ok, user_id}
      end
    end
  end

  defp verify_user(token) do
    Phoenix.Token.verify(UserService.Endpoint, "user", token)
  end

  defp send_401(conn) do
    send_resp(conn, 401, "{errors:[\"unauthorized\"]}")
  end
end
