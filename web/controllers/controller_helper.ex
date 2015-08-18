defmodule AuthScratch.ControllerHelper do
  import Plug.Conn
  import Phoenix.Controller

  def current_user(conn) do
    conn.private.current_user || get_user(conn)
  end

  defp get_user(conn) do
    if user_id = get_session(conn, :user_id) do
      AuthScratch.Repo.get(AuthScratch.User, user_id)
    end
  end

  def put_current_user(conn, _opts) do
    if user = get_user(conn) do
      put_private(conn, :current_user, user)
    else
      conn
    end
  end
end
