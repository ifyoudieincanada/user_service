defmodule UserService.UserView do
  use UserService.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserService.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserService.UserView, "user.json")}
  end

  def render("user.json", %{user: user, token: token}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      token: token}
  end
end
