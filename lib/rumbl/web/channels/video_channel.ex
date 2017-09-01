defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel
  alias Rumbl.ContentCreation
  alias Rumbl.Web.UserView
  alias Rumbl.ContentCreation
  alias Rumbl.Web.AnnotationView

  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = ContentCreation.get_video!(video_id)

    annotations = ContentCreation.get_video_annotations_for_client(video, last_seen_id) 
    resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}

    {:ok, resp, assign(socket, :video_id, video_id)} 
  end

  def handle_in(event, params, socket) do
    user = ContentCreation.get_user(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation",params, user, socket) do
    case ContentCreation.create_annotation_with_associations(params, user, socket.assigns.video_id) do
      {:ok, annotation} ->
        broadcast! socket, "new_annotation", %{
          id: annotation.id,
          user: UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        }
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
