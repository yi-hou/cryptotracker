defmodule Cryptotracker.Repo.Migrations.CreateAlerts do
  use Ecto.Migration

  def change do
    create table(:alerts) do
      add :symbol, :string, null: false
      add :price, :float, null: false
      add :lowAlert, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:alerts, [:user_id])
  end
end
