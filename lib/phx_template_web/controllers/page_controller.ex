defmodule PhxTemplateWeb.PageController do
  use PhxTemplateWeb, :controller

  def index(conn, _params) do
    {:ok, version} = :application.get_key(:phx_template, :vsn)
    render(conn, "index.html", version: version)
  end
end
