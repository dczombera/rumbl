defmodule Rumbl.ContentCreationTest do
  use Rumbl.DataCase

  alias Rumbl.ContentCreation

  describe "users" do
    alias Rumbl.ContentCreation.User

    @valid_attrs %{name: "some name", password: "some password", username: "some username"}
    @update_attrs %{name: "some updated name", password: "some updated password", username: "some updated username"}
    @invalid_attrs %{name: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContentCreation.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert ContentCreation.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert ContentCreation.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = ContentCreation.create_user(@valid_attrs)
      assert user.name == "some name"
      assert user.password == "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentCreation.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = ContentCreation.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.name == "some updated name"
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentCreation.update_user(user, @invalid_attrs)
      assert user == ContentCreation.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = ContentCreation.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> ContentCreation.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = ContentCreation.change_user(user)
    end
  end

  describe "videos" do
    alias Rumbl.ContentCreation.Video

    @valid_attrs %{description: "some description", title: "some title", url: "some url"}
    @update_attrs %{description: "some updated description", title: "some updated title", url: "some updated url"}
    @invalid_attrs %{description: nil, title: nil, url: nil}

    def video_fixture(attrs \\ %{}) do
      {:ok, video} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContentCreation.create_video()

      video
    end

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert ContentCreation.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert ContentCreation.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      assert {:ok, %Video{} = video} = ContentCreation.create_video(@valid_attrs)
      assert video.description == "some description"
      assert video.title == "some title"
      assert video.url == "some url"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContentCreation.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      assert {:ok, video} = ContentCreation.update_video(video, @update_attrs)
      assert %Video{} = video
      assert video.description == "some updated description"
      assert video.title == "some updated title"
      assert video.url == "some updated url"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = ContentCreation.update_video(video, @invalid_attrs)
      assert video == ContentCreation.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = ContentCreation.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> ContentCreation.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = ContentCreation.change_video(video)
    end
  end
end
