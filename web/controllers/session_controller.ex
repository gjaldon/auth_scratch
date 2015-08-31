defmodule AuthScratch.SessionController do
  use AuthScratch.Web, :controller

  alias AuthScratch.User

  plug :scrub_params, "login" when action in [:create]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"login" => login_params}) do
    %{"email" => email, "password" => password} = login_params

    if email && password do
      user = Repo.get_by(User, email: email)
      login(conn, user, password)
    else
      conn
      |> put_flash(:error, "You must provide an email or password")
      |> render("index.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_session(:user_id, nil)
    |> put_private(:current_user, nil)
    |> put_flash(:info, "Successfully signed out!")
    |> redirect(to: "/")
  end

  defp login(conn, nil, _password) do
    conn
    |> put_flash(:error, "Account does not exist.")
    |> render("index.html")
  end

  defp login(conn, user, password) do
    if authenticate(user, password) do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Login successful!")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:error, "Authentication failed. Password was incorrect.")
      |> render("index.html")
    end
  end

  defp authenticate(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.password)
  end
end
