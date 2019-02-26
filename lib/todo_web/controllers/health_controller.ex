defmodule TodoWeb.HealthController do
  use TodoWeb, :controller

  def check(conn, _params) do
    case database_check() do
      :ok -> respond(conn, "healthcheck passed", 204, results())
      :error -> respond(conn, "healthcheck failed", 500, results())
    end
  end

  defp results do
    # results = {status_code, %{ "X-Todo-Version" => 1.0, "X-Environment" => Mix.env() }, []}
    "OK"
  end

  defp respond(conn, message, _code, results) do
    {:ok, response} = Jason.encode(%{message: message, results: results})
    text(conn, response)
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