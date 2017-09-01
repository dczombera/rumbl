defmodule Rumbl.ContentCreation do
  @moduledoc """
  The boundary for the ContentCreation system.
  """

  import Ecto.Query, warn: false
  import Ecto, only: [assoc: 2, build_assoc: 3]

  alias Rumbl.Repo
  alias Rumbl.ContentCreation.User
  alias Rumbl.ContentCreation.Video
  alias Rumbl.ContentCreation.Category
  alias Rumbl.ContentCreation.Annotation

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Fetches a single user from the query.
  Returns  `nil` if no result was found.

  ## Example

      iex> get_by(username: "Heisenberg")

  """
  def get_user_by(param), do: Repo.get_by(User, param)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Repo.all(Video)
  end

  def list_user_videos(user) do
    Repo.all(user_videos(user))
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  def get_user_video!(user, id), do: Repo.get!(user_videos(user), id)
   
  def get_video_annotations_for_client(video \\ %Video{}, starting_from_id) do
    Repo.all(
      from a in assoc(video, :annotations),
        where:    a.id > ^starting_from_id,
        order_by: [asc: a.at, asc: a.id],
        limit:    200,
        preload:  [:user]
    )
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_video(user, attrs \\ %{}) do
    user
    |> Video.user_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  def change_user_video(user) do
    Video.user_changeset(user, %{})
  end

  defp user_videos(user) do
    assoc(user, :videos)
  end

  #
  ## CATEGORY
  #

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  def load_categories_names_and_ids_alphabetically do
    Category
    |> categories_alphabetical
    |> categories_names_and_ids
    |> Repo.all
  end

  def categories_alphabetical(query) do
    Category.alphabetical(query)
  end

  def categories_names_and_ids(query) do
    Category.names_and_ids(query)
  end

  #
  ## ANNOTATION 
  #
  
  def create_annotation_with_associations(attrs \\ %{}, user \\ %User{}, video_id \\ nil) do
    user
    |> build_assoc(:annotations, video_id: video_id)
    |> change_annotation(attrs)
    |> Repo.insert
  end

  def change_annotation(%Annotation{} = annotation, %{} = attrs) do
    Annotation.changeset(annotation, attrs)
  end
end
