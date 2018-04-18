defmodule Cryptotracker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cryptotracker.Users.User
  alias Cryptotracker.FavouritesList.Favourite

  schema "users" do
    field :email, :string, null: false
    field :firstname, :string, null: false
    field :lastname, :string, null: false
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:firstname, :lastname, :email, :password_hash])
  end

  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  def put_pass_hash(changeset), do: changeset

  def valid_password?(password) when byte_size(password) > 3 do
    {:ok, password}
  end
  def valid_password?(_), do: {:error, "The password is too short"}
end
