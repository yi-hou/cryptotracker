defmodule Cryptotracker.Notification.Alert do
  use Ecto.Schema
  import Ecto.Changeset


  schema "alerts" do
    field :lowAlert, :boolean, default: false
    field :price, :float
    field :symbol, :string
    belongs_to :user, Cryptotracker.Users.User

    timestamps()
  end

  @doc false
  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [:symbol, :price, :lowAlert, :user_id])
    |> validate_required([:symbol, :price, :lowAlert, :user_id])
  end
end
