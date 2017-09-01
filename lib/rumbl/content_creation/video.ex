defmodule Rumbl.ContentCreation.Video do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto, only: [build_assoc: 3]
  alias Rumbl.ContentCreation.Video
  alias Rumbl.ContentCreation.User
  alias Rumbl.ContentCreation.Annotation
  alias Rumbl.ContentCreation.Category

  @primary_key {:id, Rumbl.Permalink, autogenerate: true}
  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string

    has_many :annotations, Annotation

    belongs_to :user, User
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> slugify_title()
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
  end

  def user_changeset(%User{} = user, attrs) do
    user
    |> build_assoc(:videos, %{})
    |> changeset(attrs)
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  defp slugify(str) do
   str
   |> String.downcase
   |> String.replace(~r/[^\w-]+/u, "-")
  end

  defimpl Phoenix.Param, for: Video do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end
end
