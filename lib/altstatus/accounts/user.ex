defmodule Altstatus.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    belongs_to :batch, Altstatus.Admission.Batch

    timestamps()

    field :password, :string, virtual: true
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :batch_id])
    |> validate_required([:name, :email, :batch_id])
    |> unique_constraint(:email)
    |> hash_password
  end

  def hash_password(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, hashpwsalt(password))
    else
      changeset
    end
  end
end
