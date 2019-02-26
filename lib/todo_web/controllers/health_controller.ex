defmodule TodoWeb.HealthController do
  use TodoWeb, :controller

  alias Todo.{Repo}

  def check(conn, _params) do
    results = results() |> Jason.encode()

    case database_check do
      :ok -> respond(conn, "healthcheck passed", 204, results)
      :error -> respond(conn, "healthcheck failed", 500, results)
    end
  end

  defp results do
    # results = {status_code, %{ "X-Todo-Version" => 1.0, "X-Environment" => Mix.env() }, []}
    "OK"
  end

  defp respond(conn, message, code, results) do
    text(conn, message)
  end

  defp database_check do
    try do
      Ecto.Adapters.SQL.query(Todo.Repo, "select 1", [])
      :ok
    rescue
      e in DBConnection.ConnectionError -> :error
    end
  end

end
