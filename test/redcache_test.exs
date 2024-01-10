defmodule RedCacheTest do
  use ExUnit.Case
  doctest RedCache

  test "get and set" do
    "OK" = Test.Cache.set!("foo", "bar")
    assert Test.Cache.get!("foo") == "bar"
  end

  test "hmset and hgetall" do
    "OK" = Test.Cache.hmset!("test", %{"a" => 1, "b" => 2})
    assert Test.Cache.hgetall!("test") == %{"a" => 1, "b" => 2}
  end

  test "del" do
    "OK" = Test.Cache.hmset!("test", %{"a" => 1, "b" => 2})
    Test.Cache.del!("test")
    assert Test.Cache.hgetall!("test") == %{}
  end
end
