defmodule TodoWeb.HealthController do
  use TodoWeb, :controller

  use PhoenixSwagger

  swagger_path :check do
    get("/__healthcheck__")
    description("Basic health check")
    response(200, "Success")
  end

  def check(conn, _params) do
    case database_check() do
      :ok -> respond(conn, "healthcheck passed", 200, results())
      :error -> respond(conn, "healthcheck failed", 500, results())
    end
  end

  defp results do
    %{
      "X-Todo-Version": 1.0,
      "X-Environment": Mix.env(),
      database: Todo.Repo.config()[:database]
    }
  end

  defp respond(conn, message, code, results) do
    conn
    |> put_status(code)
    |> put_resp_header("content-type", "application/json")
    |> json(%{message: message, results: results})
  end

  defp database_check do
    try do
      Ecto.Adapters.SQL.query(Todo.Repo, "select 1", [])
      :ok
    rescue
      _ in DBConnection.ConnectionError -> :error
    end
  end
end
