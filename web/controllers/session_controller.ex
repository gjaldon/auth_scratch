defmodule AuthScratch.SessionController do
  use AuthScratch.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
