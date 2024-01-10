# RedCache

this is a simple redis cache wrapper for elixir, it's based on [redix] [poolboy]

## Features
- [x] set
- [x] get
- [x] expire
- [x] setex
- [x] setnx
- [x] del
- [x] incr
- [x] decr
- [x] incrby
- [x] decrby
- [x] hset
- [x] hget
- [x] hdel
- [x] hincrby
- [x] hdecrby
- [x] hgetall
- [x] hkeys
- [] hvals
- [] hlen

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `redcache` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:redcache, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/redcache>.


## USAGE

```elixir

defmodule MyCache do
  use RedCache
end

## in config.exs
config :red_cache, 
  redis_url: "redis://redis:6379",
  pool_size: 10,
  pool_max_overflow: 5,

## in runtime.exs
config :red_cache,
  redis_url: {:system, "REDIS_URL"},
  pool_size: 32,
  pool_max_overflow: 5,

## in application.ex
def start(_type, _args) do
  children = [
    MyCache
  ]

  opts = [strategy: :one_for_one, name: MyApp.Supervisor]
  Supervisor.start_link(children, opts)
end

## use

 "OK" = MyCache.set!("foo", "bar")
 "bar" = MyCache.get!("foo")
  MyCache.expire!("foo", 1)

```