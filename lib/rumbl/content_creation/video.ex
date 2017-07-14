defmodule Rumbl.ContentCreation.Video do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto, only: [build_assoc: 3]
  alias Rumbl.ContentCreation.Video
  alias Rumbl.ContentCreation.User
  alias Rumbl.ContentCreation.Category

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string

    belongs_to :user, User
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
  end

  def user_changeset(%User{} = user, attrs) do
    user
    |> build_assoc(:videos, %{})
    |> changeset(attrs)
  end
end
