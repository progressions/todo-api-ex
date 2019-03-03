defmodule Todo.StatsTest do
  alias Todo.Stats

  use ExUnit.Case

  test "increment records the environment in the key" do
    Stats.increment("value")
    assert_received {:increment, "test.value"}
  end
end
