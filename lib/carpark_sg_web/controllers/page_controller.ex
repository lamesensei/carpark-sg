defmodule CarparkSgWeb.PageController do
  use CarparkSgWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
