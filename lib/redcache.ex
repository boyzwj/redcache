defmodule RedCache do
  defmacro __using__(opts) do
    quote do
      opts = unquote(opts)
      @compress_level opts[:compress_level] || nil
      @pool_name Module.concat(__MODULE__, "Pool")
      @adapter Module.concat(__MODULE__, "Adapter")

      defmodule @pool_name do
        use RedCache.Pool
      end

      defmodule @adapter do
        use RedCache.Adapter
      end

      def start_link(args) do
        @pool_name.start_link(args)
      end

      def parse_key(key), do: "#{__MODULE__}:#{key}"

      ## ============================ API =================================

      ## === DBSIZE ===
      def dbsize() do
        @adapter.dbsize()
      end

      def dbsize!() do
        @adapter.dbsize!()
      end

      ## === TYPE ===
      def type(key) do
        key
        |> parse_key
        |> @adapter.type()
      end

      def type!(key) do
        key
        |> parse_key
        |> @adapter.type!()
      end

      ## === EXPIRE ===
      def expire(key, seconds, opt \\ nil) do
        key
        |> parse_key
        |> @adapter.expire(seconds, opt)
      end

      def expire!(key, seconds, opt \\ nil) do
        key
        |> parse_key
        |> @adapter.expire!(seconds, opt)
      end

      ## === EXPIREAT ===
      def expireat(key, timestamp, opt \\ nil) do
        key
        |> parse_key
        |> @adapter.expireat(timestamp, opt)
      end

      def expireat!(key, timestamp, opt \\ nil) do
        key
        |> parse_key
        |> @adapter.expireat!(timestamp, opt)
      end

      ## === EXPIRETIME ===
      def expiretime(key) do
        key
        |> parse_key
        |> @adapter.expiretime()
      end

      def expiretime!(key) do
        key
        |> parse_key
        |> @adapter.expiretime!()
      end

      ## === TTL ===
      def ttl(key) do
        key
        |> parse_key
        |> @adapter.ttl()
      end

      def ttl!(key) do
        key
        |> parse_key
        |> @adapter.ttl!()
      end

      ## === DEL ===
      def del(key) do
        key
        |> parse_key
        |> @adapter.del()
      end

      def del!(key) do
        key
        |> parse_key
        |> @adapter.del!()
      end

      ## === GETDEL ===
      def getdel(key) do
        key
        |> parse_key
        |> @adapter.getdel()
      end

      def getdel!(key) do
        key
        |> parse_key
        |> @adapter.getdel!()
      end

      ## === RENAME ===
      def rename(key, new_key) do
        key
        |> parse_key
        |> @adapter.rename(new_key)
      end

      def rename!(key, new_key) do
        key
        |> parse_key
        |> @adapter.rename!(new_key)
      end

      ## === SET ===

      def set(key, value) do
        key
        |> parse_key
        |> @adapter.set(value, @compress_level)
      end

      def set!(key, value) do
        key
        |> parse_key
        |> @adapter.set!(value, @compress_level)
      end

      ## === APPEND ===
      def append(key, value) do
        key
        |> parse_key
        |> @adapter.append(value)
      end

      def append!(key, value) do
        key
        |> parse_key
        |> @adapter.append!(value)
      end

      ## === GET ===
      def get(key) do
        key
        |> parse_key
        |> @adapter.get()
      end

      def get!(key) do
        key
        |> parse_key
        |> @adapter.get!()
      end

      ## === HDEL ===
      def hdel(table, key) do
        table
        |> parse_key
        |> @adapter.hdel(key)
      end

      def hdel!(table, key) do
        table
        |> parse_key
        |> @adapter.hdel!(key)
      end

      ## === HEXISTS ===
      def hexists(table, key) do
        table
        |> parse_key
        |> @adapter.hexists(key)
      end

      def hexists!(table, key) do
        table
        |> parse_key
        |> @adapter.hexists!(key)
      end

      ## === HGET ===
      def hget(table, key) do
        table
        |> parse_key
        |> @adapter.hget(key)
      end

      def hget!(table, key) do
        table
        |> parse_key
        |> @adapter.hget!(key)
      end

      ## === HGETALL ===
      def hgetall(table) do
        table
        |> parse_key
        |> @adapter.hgetall()
      end

      def hgetall!(table) do
        table
        |> parse_key
        |> @adapter.hgetall!()
      end

      ## === HINCRBY ===
      def hincrby(table, key, increment) do
        table
        |> parse_key
        |> @adapter.hincrby(key, increment)
      end

      def hincrby!(table, key, increment) do
        table
        |> parse_key
        |> @adapter.hincrby!(key, increment)
      end

      ## === HINCRBYFLOAT ===
      def hincrbyfloat(table, key, increment) do
        table
        |> parse_key
        |> @adapter.hincrbyfloat(key, increment)
      end

      def hincrbyfloat!(table, key, increment) do
        table
        |> parse_key
        |> @adapter.hincrbyfloat!(key, increment)
      end

      ## === HKEYS ===
      def hkeys(table) do
        table
        |> parse_key
        |> @adapter.hkeys()
      end

      def hkeys!(table) do
        table
        |> parse_key
        |> @adapter.hkeys!()
      end

      ## === HLEN ===
      def hlen(table) do
        table
        |> parse_key
        |> @adapter.hlen()
      end

      def hlen!(table) do
        table
        |> parse_key
        |> @adapter.hlen!()
      end

      ## === HSET ===
      def hset(table, key, value) do
        table
        |> parse_key
        |> @adapter.hset(key, value, @compress_level)
      end

      def hset!(table, key, value) do
        table
        |> parse_key
        |> @adapter.hset!(key, value, @compress_level)
      end

      ## === HMSET ===
      def hmset(table, map) when is_map(map) do
        table
        |> parse_key
        |> @adapter.hmset(map, @compress_level)
      end

      def hmset!(table, map) when is_map(map) do
        table
        |> parse_key
        |> @adapter.hmset!(map, @compress_level)
      end

      ## === HSETNX ===
      def hsetnx(table, key, value) do
        table
        |> parse_key
        |> @adapter.hsetnx(key, value, @compress_level)
      end

      def hsetnx!(table, key, value) do
        table
        |> parse_key
        |> @adapter.hsetnx!(key, value, @compress_level)
      end

      ## === HSTRLEN ===
      def hstrlen(table, key) do
        table
        |> parse_key
        |> @adapter.hstrlen(key)
      end

      def hstrlen!(table, key) do
        table
        |> parse_key
        |> @adapter.hstrlen!(key)
      end

      ## === BF.ADD ===
      def bfadd(key, value) do
        key
        |> parse_key
        |> @adapter.bfadd(value)
      end

      def bfadd!(key, value) do
        key
        |> parse_key
        |> @adapter.bfadd!(value)
      end

      ## === BF.CARD ===
      def bfcard(key) do
        key
        |> parse_key
        |> @adapter.bfcard()
      end

      def bfcard!(key) do
        key
        |> parse_key
        |> @adapter.bfcard!()
      end

      ## === BF.EXISTS ===
      def bfexists(key, value) do
        key
        |> parse_key
        |> @adapter.bfexists(value)
      end

      def bfexists!(key, value) do
        key
        |> parse_key
        |> @adapter.bfexists!(value)
      end

      ## === BF.INFO ===
      def bfinfo(key) do
        key
        |> parse_key
        |> @adapter.bfinfo()
      end

      def bfinfo!(key) do
        key
        |> parse_key
        |> @adapter.bfinfo!()
      end

      ## === BF.INSERT ===
      def bfinsert(key, value) do
        key
        |> parse_key
        |> @adapter.bfinsert(value)
      end

      def bfinsert!(key, value) do
        key
        |> parse_key
        |> @adapter.bfinsert!(value)
      end

      ## === BF.MADD ===
      def bfmadd(key, values) do
        key
        |> parse_key
        |> @adapter.bfmadd(values)
      end

      def bfmadd!(key, values) do
        key
        |> parse_key
        |> @adapter.bfmadd!(values)
      end

      ## === BF.MEXISTS ===
      def bfmexists(key, values) do
        key
        |> parse_key
        |> @adapter.bfmexists(values)
      end

      def bfmexists!(key, values) do
        key
        |> parse_key
        |> @adapter.bfmexists!(values)
      end

      ## === BF.RESERVE ===
      def bfreserve(key, error_rate, capacity) do
        key
        |> parse_key
        |> @adapter.bfreserve(error_rate, capacity)
      end

      def bfreserve!(key, error_rate, capacity) do
        key
        |> parse_key
        |> @adapter.bfreserve!(error_rate, capacity)
      end

      ## === BF.LOADCHUNK ===
      def bfloadchunk(key, chunk) do
        key
        |> parse_key
        |> @adapter.bfloadchunk(chunk)
      end

      def bfloadchunk!(key, chunk) do
        key
        |> parse_key
        |> @adapter.bfloadchunk!(chunk)
      end

      ## === BF.SCANDUMP ===
      def bfscandump(key, iterator) do
        key
        |> parse_key
        |> @adapter.bfscandump(iterator)
      end

      def bfscandump!(key, iterator) do
        key
        |> parse_key
        |> @adapter.bfscandump!(iterator)
      end
    end
  end
end
