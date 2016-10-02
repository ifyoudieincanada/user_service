defmodule UserService.PermissionView do
  use UserService.Web, :view

  def render("index.json", %{permissions: permissions}) do
    %{data: render_many(permissions, UserService.PermissionView, "permission.json")}
  end

  def render("show.json", %{permission: permission}) do
    %{data: render_one(permission, UserService.PermissionView, "permission.json")}
  end

  def render("permission.json", %{permission: permission}) do
    %{id: permission.id,
      name: permission.name,
      description: permission.description,
      user_id: permission.user_id}
  end
end
