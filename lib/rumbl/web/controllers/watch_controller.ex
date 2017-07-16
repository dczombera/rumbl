defmodule Rumbl.Web.WatchController do
  use Rumbl.Web, :controller 
  alias Rumbl.ContentCreation

  def show(conn, %{"id" => id}) do
    video = ContentCreation.get_video!(id) 
    render conn, "show.html", video: video
  end
end
