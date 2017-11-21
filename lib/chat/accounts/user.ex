defmodule Chat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chat.Accounts.User

  @derive {Poison.Encoder, only: [:id, :username]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    has_many :conversations, Chat.Chats.Conversation, foreign_key: :creator_id
    has_many :participants, Chat.Chats.Conversation, foreign_key: :creator_id
    has_many :messages, Chat.Chats.Conversation, foreign_key: :creator_id

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([])
  end
end
