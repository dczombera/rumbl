defmodule Rumbl.ContentCreation.UserRepoTest do
  use Rumbl.DataCase
  alias Rumbl.ContentCreation.User

  @valid_attrs %{name: "Han", username: "smuggler"}

  test "converts unique_constraint on username to error" do
    insert_user(%{username: "smuggler"})
    changeset = User.changeset(%User{}, @valid_attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert {:username, ["has already been taken"]} in errors_on(changeset) 
  end
end
