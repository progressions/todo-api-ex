defmodule TodoWeb.HealthControllerTest do
  use TodoWeb.ConnCase

  test "GET /__healthcheck__ returns OK", %{conn: conn} do
    conn =
      conn
      |> get("/__healthcheck__")

    {:ok, json} = response(conn, 200) |> Jason.decode()

    assert json == %{
             "message" => "healthcheck passed",
             "results" => %{
               "X-Environment" => "test",
               "X-Todo-Version" => 1.0,
               "database" => Todo.Repo.config()[:database]
             }
           }
  end
end
