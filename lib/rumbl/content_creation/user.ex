defmodule Rumbl.ContentCreation.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.ContentCreation.User
  alias Rumbl.ContentCreation.Video
  alias Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :videos, Video

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  def registration_changeset(%User{} = user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
