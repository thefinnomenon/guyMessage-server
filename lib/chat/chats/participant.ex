defmodule Chat.Chats.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chat.Chats.Participant

  @derive {Poison.Encoder, only: [:user]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "participants" do
    belongs_to :conversation, Chat.Chats.Conversation
    belongs_to :user, Chat.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Participant{} = participant, attrs) do
    participant
    |> cast(attrs, [:user_id, :conversation_id])
    |> validate_required([])
  end
end
