defmodule AuthScratch.RegistrationController do
  use AuthScratch.Web, :controller

  alias AuthScratch.User

  plug :scrub_params, "register" when action in [:create]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"register" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Registration successful.")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "index.html")
    end
  end
end
