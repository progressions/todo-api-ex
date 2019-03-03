defmodule Todo.TokenGeneratorTest do
  alias Todo.TokenGenerator

  use ExUnit.Case

  @user_id "1234"

  test "generate_and_cache_token" do
    {:ok, token} = TokenGenerator.generate_and_cache_token(@user_id)
    assert TokenGenerator.get_token(token) == {:ok, @user_id}
  end
end
