defmodule Rumbl.Web.VideoControllerTest do
  use Rumbl.Web.ConnCase 

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :new)),
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "42")),
      get(conn, video_path(conn, :edit, "42")),
      patch(conn, video_path(conn, :update, "42", %{})),
      post(conn, video_path(conn, :create, %{})),
      delete(conn, video_path(conn, :delete, "42"))
    ], fn conn ->
      assert html_response(conn, 302) 
      assert conn.halted
    end)
  end
end
