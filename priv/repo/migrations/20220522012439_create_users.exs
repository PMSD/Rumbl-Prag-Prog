defmodule Rumbl.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string
      add :username, :string, null: false
      add :password_hash, :string

      timestamps()
    end
    create unique_index(:user, [:username])
  end
end
