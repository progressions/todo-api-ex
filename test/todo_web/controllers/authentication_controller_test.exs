defmodule Todo.AuthenticationControllerTest do
  use TodoWeb.ConnCase

  test "POST /api/authenticate without authentication throws 401", %{conn: conn} do
    conn = post(conn, "/api/authenticate")
    assert response(conn, 401) == "unauthorized"
  end

  test "POST /api/authenticate with invalid auth header throws 401", %{conn: conn} do
    conn =
      conn
      |> with_invalid_authorization_header
      |> post("/api/authenticate")

    assert response(conn, 401) == "unauthorized"
  end

  test "POST /api/authenticate with auth header is OK", %{conn: conn} do
    conn =
      conn
      |> with_valid_authorization_header
      |> post("/api/authenticate")

    assert %{"expires_at" => _, "token" => _} = json_response(conn, 200)
    assert_received {:increment, "test.user.authenticate"}
  end
end
