defmodule Rumbl.Web.AnnotationView do
  use Rumbl.Web, :view
  alias Rumbl.Web.UserView

  def render("annotation.json", %{annotation: an}) do
    %{
      id: an.id,
      body: an.body,
      at: an.at,
      user: render_one(an.user, UserView, "user.json")
    }
  end
end
