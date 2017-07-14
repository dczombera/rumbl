defmodule Rumbl.TestHelpers do
  alias Rumbl.Repo
  alias Rumbl.ContentCreation.User

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      name: "Han Solo",
      username: "smuggler#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      password: "WookieLover"
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!() 
  end
end
