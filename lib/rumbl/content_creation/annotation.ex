defmodule Rumbl.ContentCreation.Annotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.ContentCreation.Annotation
  alias Rumbl.ContentCreation.User
  alias Rumbl.ContentCreation.Video


  schema "annotations" do
    field :at, :integer
    field :body, :string

    belongs_to :user, User
    belongs_to :video, Video

    timestamps()
  end

  @doc false
  def changeset(%Annotation{} = annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
