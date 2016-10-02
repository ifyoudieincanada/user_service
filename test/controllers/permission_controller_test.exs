defmodule UserService.PermissionControllerTest do
  use UserService.ConnCase

  alias UserService.Permission
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, permission_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = get conn, permission_path(conn, :show, permission)
    assert json_response(conn, 200)["data"] == %{"id" => permission.id,
      "name" => permission.name,
      "description" => permission.description,
      "user_id" => permission.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, permission_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, permission_path(conn, :create), permission: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Permission, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, permission_path(conn, :create), permission: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = put conn, permission_path(conn, :update, permission), permission: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Permission, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = put conn, permission_path(conn, :update, permission), permission: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = delete conn, permission_path(conn, :delete, permission)
    assert response(conn, 204)
    refute Repo.get(Permission, permission.id)
  end
end
