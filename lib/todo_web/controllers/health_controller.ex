defmodule TodoWeb.HealthController do
  use TodoWeb, :controller

  alias Todo.{Repo}

  import TodoWeb.ErrorHelpers

  def check(conn, _params) do
    text(conn, "OK")
  end

end
