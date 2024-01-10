defmodule RedCache.Adapter do
  alias RedCache.TermEncoder

  defmacro __using__(_opts) do
    quote do
      @pool __MODULE__
            |> Module.split()
            |> Enum.drop(-1)
            |> Enum.concat(["Pool"])
            |> Module.concat()

      ##  === DBSIZE ===
      def dbsize() do
        @pool.command(["DBSIZE"])
      end

      def dbsize!() do
        @pool.command!(["DBSIZE"])
      end

      ### === TYPE ===
      def type(key) do
        @pool.command(["TYPE", key])
      end

      def type!(key) do
        @pool.command!(["TYPE", key])
      end

      ## === EXPIRE ===
      def expire(key, seconds, opt \\ nil) do
        cmd = (opt && ["EXPIRE", key, seconds, opt]) || ["EXPIRE", key, seconds]
        @pool.command(cmd)
      end

      def expire!(key, seconds, opt \\ nil) do
        cmd = (opt && ["EXPIRE", key, seconds, opt]) || ["EXPIRE", key, seconds]
        @pool.command!(cmd)
      end

      ## === EXPIREAT ===
      def expireat(key, timestamp, opt \\ nil) do
        cmd = (opt && ["EXPIREAT", key, timestamp, opt]) || ["EXPIREAT", key, timestamp]
        @pool.command(cmd)
      end

      def expireat!(key, timestamp, opt \\ nil) do
        cmd = (opt && ["EXPIREAT", key, timestamp, opt]) || ["EXPIREAT", key, timestamp]
        @pool.command!(cmd)
      end

      ## === EXPIRETIME ===
      def expiretime(key) do
        @pool.command(["EXPIRETIME", key])
      end

      def expiretime!(key) do
        @pool.command!(["EXPIRETIME", key])
      end

      ### === TTL ===
      def ttl(key) do
        @pool.command(["TTL", key])
      end

      def ttl!(key) do
        @pool.command!(["TTL", key])
      end

      ## === DEL ===
      def del(key) do
        @pool.command(["DEL", key])
      end

      def del!(key) do
        @pool.command!(["DEL", key])
      end

      ## === GETDEL ===
      def getdel(key) do
        @pool.command(["GETDEL", key])
      end

      def getdel!(key) do
        @pool.command!(["GETDEL", key])
      end

      ## === RENAME ===
      def rename(key, new_key) do
        @pool.command(["RENAME", key, new_key])
      end

      def rename!(key, new_key) do
        @pool.command!(["RENAME", key, new_key])
      end

      ## === SET ===
      def set(key, value, compress_level) do
        value = TermEncoder.encode(value, compress_level)
        @pool.command(["SET", key, value])
      end

      def set!(key, value, compress_level) do
        value = TermEncoder.encode(value, compress_level)
        @pool.command!(["SET", key, value])
      end

      ## === APPEND ===
      def append(key, value) do
        @pool.command(["APPEND", key, value])
      end

      def append!(key, value) do
        @pool.command!(["APPEND", key, value])
      end

      ## === GET ===
      def get(key) do
        case @pool.command(["GET", key]) do
          {:ok, value} ->
            {:ok, TermEncoder.decode(value)}

          _ ->
            {:ok, nil}
        end
      end

      def get!(key) do
        @pool.command!(["GET", key])
        |> TermEncoder.decode()
      end

      ## === HDEL ===
      def hdel(table, key) do
        @pool.command(["HDEL", table, key])
      end

      def hdel!(table, key) do
        @pool.command!(["HDEL", table, key])
      end

      ## === HEXISTS ===
      def hexists(table, key) do
        @pool.command(["HEXISTS", table, key])
      end

      def hexists!(table, key) do
        @pool.command!(["HEXISTS", table, key])
      end

      ## === HGET ===
      def hget(table, key) do
        with {:ok, value} <- @pool.command(["HGET", table, key]) do
          {:ok, TermEncoder.decode(value)}
        else
          result ->
            result
        end
      end

      def hget!(table, key) do
        @pool.command!(["HGET", table, key]) |> TermEncoder.decode()
      end

      ## === HGETALL ===
      def hgetall(table) do
        case @pool.command(["HGETALL", table]) do
          {:ok, value} ->
            value
            |> Enum.chunk_every(2)
            |> Enum.map(fn [k, v] -> {k, TermEncoder.decode(v)} end)
            |> Enum.into(%{})
            |> then(&{:ok, &1})

          _ ->
            {:ok, nil}
        end
      end

      def hgetall!(table) do
        @pool.command!(["HGETALL", table])
        |> then(fn value ->
          value
          |> Enum.chunk_every(2)
          |> Enum.map(fn [k, v] -> {k, TermEncoder.decode(v)} end)
          |> Enum.into(%{})
        end)
      end

      ## === HINCRBY ===
      def hincrby(table, key, increment) do
        @pool.command(["HINCRBY", table, key, increment])
      end

      def hincrby!(table, key, increment) do
        @pool.command!(["HINCRBY", table, key, increment])
      end

      ## === HINCRBYFLOAT ===
      def hincrbyfloat(table, key, increment) do
        @pool.command(["HINCRBYFLOAT", table, key, increment])
      end

      def hincrbyfloat!(table, key, increment) do
        @pool.command!(["HINCRBYFLOAT", table, key, increment])
      end

      ## === HKEYS ===
      def hkeys(table) do
        @pool.command(["HKEYS", table])
      end

      def hkeys!(table) do
        @pool.command!(["HKEYS", table])
      end

      ## === HLEN ===
      def hlen(table) do
        @pool.command(["HLEN", table])
      end

      def hlen!(table) do
        @pool.command!(["HLEN", table])
      end

      ## === HSET ===
      def hset(table, key, value, compress_level) do
        value = TermEncoder.encode(value, compress_level)
        @pool.command(["HSET", table, key, value])
      end

      def hset!(table, key, value, compress_level) do
        value = TermEncoder.encode(value, compress_level)
        @pool.command!(["HSET", table, key, value])
      end

      ## === HMSET ===
      def hmset(table, map, compress_level) when is_map(map) do
        list =
          Enum.map(map, fn {k, v} -> [k, TermEncoder.encode(v, compress_level)] end)
          |> List.flatten()

        @pool.command(["HMSET", table | list])
      end

      def hmset!(table, map, compress_level) when is_map(map) do
        list =
          Enum.map(map, fn {k, v} -> [k, TermEncoder.encode(v, compress_level)] end)
          |> List.flatten()

        @pool.command!(["HMSET", table | list])
      end

      ## === HSETNX ===
      def hsetnx(table, key, value, compress_level) do
        value = TermEncoder.encode(value, compress_level)
        @pool.command(["HSETNX", table, key, value])
      end

      def hsetnx!(table, key, value, compress_level) do
        value = TermEncoder.encode(value, compress_level)
        @pool.command!(["HSETNX", table, key, value])
      end

      ## === HSTRLEN ===
      def hstrlen(table, key) do
        @pool.command(["HSTRLEN", table, key])
      end

      def hstrlen!(table, key) do
        @pool.command!(["HSTRLEN", table, key])
      end

      ## === BF.ADD ===
      def bfadd(key, value) do
        @pool.command(["BF.ADD", key, value])
      end

      def bfadd!(key, value) do
        @pool.command!(["BF.ADD", key, value])
      end

      ## === BF.CARD ===
      def bfcard(key) do
        @pool.command(["BF.CARD", key])
      end

      def bfcard!(key) do
        @pool.command!(["BF.CARD", key])
      end

      ## === BF.EXISTS ===
      def bfexists(key, value) do
        @pool.command(["BF.EXISTS", key, value])
      end

      def bfexists!(key, value) do
        @pool.command!(["BF.EXISTS", key, value])
      end

      ## === BF.INFO ===
      def bfinfo(key) do
        @pool.command(["BF.INFO", key])
      end

      def bfinfo!(key) do
        @pool.command!(["BF.INFO", key])
      end

      ## === BF.INSERT ===
      def bfinsert(key, value) do
        @pool.command(["BF.INSERT", key, value])
      end

      def bfinsert!(key, value) do
        @pool.command!(["BF.INSERT", key, value])
      end

      ## === BF.MADD ===
      def bfmadd(key, values) do
        @pool.command(["BF.MADD", key | values])
      end

      def bfmadd!(key, values) do
        @pool.command!(["BF.MADD", key | values])
      end

      ## === BF.MEXISTS ===
      def bfmexists(key, values) do
        @pool.command(["BF.MEXISTS", key | values])
      end

      def bfmexists!(key, values) do
        @pool.command!(["BF.MEXISTS", key | values])
      end

      ## === BF.RESERVE ===
      def bfreserve(key, error_rate, capacity) do
        @pool.command(["BF.RESERVE", key, error_rate, capacity])
      end

      def bfreserve!(key, error_rate, capacity) do
        @pool.command!(["BF.RESERVE", key, error_rate, capacity])
      end

      ## === BF.LOADCHUNK ===
      def bfloadchunk(key, iterator, data) do
        @pool.command(["BF.LOADCHUNK", key, iterator, data])
      end

      def bfloadchunk!(key, iterator, data) do
        @pool.command!(["BF.LOADCHUNK", key, iterator, data])
      end

      ## === BF.SCANDUMP ===
      def bfscandump(key, iterator) do
        @pool.command(["BF.SCANDUMP", key, iterator])
      end

      def bfscandump!(key, iterator) do
        @pool.command!(["BF.SCANDUMP", key, iterator])
      end
    end
  end
end
