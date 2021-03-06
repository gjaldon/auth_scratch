defmodule AuthScratch.User do
  use AuthScratch.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      change(changeset, %{password: Comeonin.Bcrypt.hashpwsalt(password)})
    else
      changeset
    end
  end
end
