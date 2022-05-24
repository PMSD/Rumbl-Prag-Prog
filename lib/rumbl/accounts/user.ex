defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true #virtual fields exist in the struct but not the database
    field :password_hash, :string

    timestamps()
  end
  
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username]) #converts raw map of user to a changeset containing :name and :username keys
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()

  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
    
      _ ->
        changeset
    end
  end

end
