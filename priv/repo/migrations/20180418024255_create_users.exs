defmodule Cryptotracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :password, :string
      add :password_confirmation, :string
      add :password_hash, :string

      timestamps()
    end

  end
end
