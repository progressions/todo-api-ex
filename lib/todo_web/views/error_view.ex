defmodule TodoWeb.ErrorView do
  use TodoWeb, :view

  def render("404.json", assigns) do
    %{errors: %{detail: assigns[:error] || "Resource not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  def render("400.json", %{error: message}) do
    %{errors: %{detail: message}}
  end

  def render("422.json", %{errors: [{:user_id, {"Name must be unique", _}}|_]}) do
    %{errors: %{detail: "Name must be unique"}}
  end

  def render("422.json", assigns) do
    %{errors: %{detail: assigns[:errors] || "Bad request"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end
end
