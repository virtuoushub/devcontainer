defmodule WorkspaceWeb.PageController do
  use WorkspaceWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
