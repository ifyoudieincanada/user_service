defmodule UserService.PermissionTest do
  use UserService.ModelCase

  alias UserService.Permission

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Permission.changeset(%Permission{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Permission.changeset(%Permission{}, @invalid_attrs)
    refute changeset.valid?
  end
end
