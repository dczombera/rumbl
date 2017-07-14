defmodule Rumbl.Web.UserView do
  use Rumbl.Web, :view

  alias Rumbl.ContentCreation.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
