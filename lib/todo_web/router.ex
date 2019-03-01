defmodule TodoWeb.Router do
  use TodoWeb, :router

  require Logger

  use Plug.ErrorHandler

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
  end

  pipeline :basic_auth do
    plug(BasicAuth)
  end

  pipeline :token_auth do
    plug(TokenAuth)
  end

  scope "/", TodoWeb do
    pipe_through(:api)
    get("/__healthcheck__", HealthController, :check)
  end

  # Other scopes may use custom stacks.

  scope "/api", TodoWeb do
    pipe_through([:api, :basic_auth])

    post("/authenticate", AuthenticationController, :authenticate)
  end

  scope "/api", TodoWeb do
    pipe_through([:api, :token_auth])

    get("/lists", ListController, :index)
    get("/lists/:id", ListController, :show)
    post("/lists", ListController, :create)
    delete("/lists/:id", ListController, :delete)
    patch("/lists/:id", ListController, :update)

    post("/lists/:list_id/items", ItemController, :create)
    put("/lists/:list_id/items/:id/finish", ItemController, :finish)
    delete("/lists/:list_id/items/:id", ItemController, :delete)
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :todo,
      swagger_file: "swagger.json",
      disable_validator: true
    )
  end

  defp handle_errors(%Plug.Conn{status: 500} = conn, %{
         kind: kind,
         reason: reason,
         stack: stacktrace
       }) do
    Plug.LoggerJSON.log_error(kind, reason, stacktrace)
    send_resp(conn, 500, Jason.encode!(%{errors: %{detail: "Internal server error"}}))
  end

  defp handle_errors(_, _), do: nil

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Todoable"
      }
    }
  end
end
