defmodule Todo.CacheTest do
  alias Todo.Cache

  use ExUnit.Case

  test "cache" do
    Cache.set("token", 100)
    assert Cache.get("token") == 100
  end

  test "cache timeout" do
    Cache.setex("token", 1200, "abcdef")
    assert Cache.get("token") == "abcdef"
  end

  test "cache timeout expired" do
    Cache.setex("token", -1200, "abcdef")
    assert Cache.get("token") == nil
  end

  test "cache get unknown key" do
    assert Cache.get("not set token") == nil
  end
end
