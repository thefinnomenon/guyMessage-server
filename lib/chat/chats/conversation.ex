defmodule Chat.Chats.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chat.Repo
  alias Chat.Chats.Conversation

  @derive {Poison.Encoder, only: [:id, :creator_id, :participants, :messages]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "conversations" do
    belongs_to :creator, Chat.Accounts.User
    has_many :participants, Chat.Chats.Participant
    has_many :messages, Chat.Chats.Message

    timestamps()
  end

  @doc false
  def changeset(%Conversation{} = conversation, attrs) do
    conversation
    |> cast(attrs, [:creator_id])
    |> cast_assoc(:participants, required: true)
    |> validate_required([])
  end
end
