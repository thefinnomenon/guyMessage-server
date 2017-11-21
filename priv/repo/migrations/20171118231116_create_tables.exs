defmodule Chat.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
  	create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      timestamps()
    end

    create table(:conversations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :creator_id, references(:users, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create table(:participants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :conversation_id, references(:conversations, on_delete: :delete_all, type: :uuid)
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :conversation_id, references(:conversations, on_delete: :delete_all, type: :uuid)
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
      add :message, :string

      timestamps()
    end
  end
end
