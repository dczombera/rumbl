defmodule Rumbl.Web.UserController do
  use Rumbl.Web, :controller

  plug :authenticate_user when action in [:index, :show]

  alias Rumbl.ContentCreation
  alias Rumbl.ContentCreation.User
  alias Rumbl.Auth

  def index(conn, _params) do
    users = ContentCreation.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = ContentCreation.get_user(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = ContentCreation.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case ContentCreation.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
