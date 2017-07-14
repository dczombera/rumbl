defmodule Rumbl.AuthTest do
  use Rumbl.Web.ConnCase
  alias Rumbl.Auth
  alias Rumbl.ContentCreation.User
  alias Rumbl.ContentCreation

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Rumbl.Web.Router, :browser)
      |> get("/") 

    {:ok, %{conn: conn}}
  end

  test "authenticate_user/2 halts when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted()
  end

  test "authenticate_user/2 continues when current_user exists", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %User{})
      |> Auth.authenticate_user([]) 

    refute conn.halted()
  end

  test "login puts the user in the session", %{conn: conn} do
    login_conn =
      conn
      |> Auth.login(%User{id: 42})
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == 42
  end

  test "logout drops the session", %{conn: conn} do
    logout_conn =
      conn
      |> put_session(:user_id, 42)
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  test "call places user from session into assigns", %{conn: conn} do
    user = insert_user()
    conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call(ContentCreation)

    assert conn.assigns.current_user.id == user.id
  end

  test "call with no session sets current_user assign to nil", %{conn: conn} do
    conn = Auth.call(conn, ContentCreation)
    assert conn.assigns.current_user == nil
  end

  test "login with a valid username and password", %{conn: conn} do
    user = insert_user(%{username: "han", password: "wookiepower"})
    {:ok, conn} = Auth.login_by_username_and_password(conn, "han", "wookiepower", context: ContentCreation)
    
    assert conn.assigns.current_user.id == user.id
  end

  test "login with a wrong password", %{conn: conn} do
    _ = insert_user(%{username: "han", password: "wookiepower"})
    {:error, :unauthorized, _conn} = Auth.login_by_username_and_password(conn, "han", "wrong", context: ContentCreation) 
  end

  test "login with a non-existing user", %{conn: conn} do
    {:error, :not_found, _conn} = Auth.login_by_username_and_password(conn, "han", "wookiepower", context: ContentCreation)
  end
end
