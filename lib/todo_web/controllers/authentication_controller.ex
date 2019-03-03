defmodule TodoWeb.AuthenticationController do
  use TodoWeb, :controller
  use Timex
  use PhoenixSwagger

  swagger_path :authenticate do
    post("/api/authenticate")
    description("Authenticate with basic auth and get a token back")
    response(200, "Success")
    security("basicAuth")
  end

  def authenticate(conn, _params) do
    with user <- Todo.UserSession.current_user(conn),
         {:ok, token} <- Todo.TokenGenerator.generate_and_cache_token(user.id) do
      render(conn, "authenticate.json", %{
        token: token,
        expires_at: expires_at()
      })
    end
  end

  defp expires_at do
    Timex.now()
    |> Timex.add(Duration.from_minutes(20))
    |> case do
      {:ok, date} -> DateTime.to_string(date)
      _ -> nil
    end
  end

  def swagger_definitions do
    %{
      Token:
        swagger_schema do
          title("Authentication Token")
          description("Authentication token, expires in 20 minutes")

          properties do
            token(:string, "Authentication Token")
            expires_at(:datetime, "Expiration date")
          end
        end
    }
  end
end
