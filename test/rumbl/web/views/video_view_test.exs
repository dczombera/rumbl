defmodule Rumbl.VideoViewTest do
  use Rumbl.Web.ConnCase, async: true
  import Phoenix.View
  alias Rumbl.ContentCreation.Video

  test "renders index.html", %{conn: conn} do
    videos = [
      %Video{id: "1", title: "Release the kraken"},
      %Video{id: "42", title: "Han shot first"}
    ]
    content = render_to_string(Rumbl.Web.VideoView, "index.html", conn: conn, videos: videos)

    assert String.contains?(content, "Listing Videos")
    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Video.changeset(%Video{}, %{})
    categories = [{"jedi", 1}]
    content = render_to_string(Rumbl.Web.VideoView, "new.html", 
      conn: conn, changeset: changeset, categories: categories)

    assert String.contains?(content, "New Video")
  end
end
