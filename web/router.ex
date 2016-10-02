defmodule UserService.Router do
  use UserService.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UserService do
    pipe_through :api

    resources "/users", UserController, except: [:index, :show, :new, :edit]
    post "/users/login", UserController, :login
    post "/users/verify", UserController, :verify

    resources "/permissions", PermissionController, except: [:new, :edit, :show, :update]
  end
end
