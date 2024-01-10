defmodule RedCache.Pool do
  defmacro __using__(_opts) do
    quote do
      @pool_name __MODULE__
                 |> Module.split()
                 |> Enum.map(&String.downcase/1)
                 |> Enum.join("_")
                 |> String.to_atom()

      use Supervisor

      def start_link(args) do
        Supervisor.start_link(__MODULE__, args, name: __MODULE__)
      end

      @impl true
      def init(opts) do
        import Supervisor.Spec, warn: false

        pool_options = [
          name: {:local, @pool_name},
          worker_module: RedCache.Pool.Worker,
          size: RedCache.Config.get(:size, 32),
          max_overflow: RedCache.Config.get(:max_overflow, 64)
        ]

        [
          :poolboy.child_spec(@pool_name, pool_options, [])
        ]
        |> Supervisor.init(strategy: :one_for_one)
      end

      @doc """
      Wrapper to call `Redix.command/3` inside a poolboy worker.

      ## Examples

          iex> RedCache.Pool.command(["SET", "k", "foo"])
          {:ok, "OK"}
          iex> RedCache.Pool.command(["GET", "k"])
          {:ok, "foo"}
      """

      def command(args, opts \\ []) do
        :poolboy.transaction(
          @pool_name,
          fn worker -> GenServer.call(worker, {:command, args, opts}) end,
          RedCache.Config.get(:timeout, 5000)
        )
      end

      @doc """
      Wrapper to call `Redix.command!/3` inside a poolboy worker, raising if
      there's an error.

      ## Examples

          iex> RedCache.Pool.command!(["SET", "k", "foo"])
          "OK"
          iex> RedCache.Pool.command!(["GET", "k"])
          "foo"
      """

      def command!(args, opts \\ []) do
        :poolboy.transaction(
          @pool_name,
          fn worker -> GenServer.call(worker, {:command!, args, opts}) end,
          RedCache.Config.get(:timeout, 5000)
        )
      end

      @doc """
      Wrapper to call `Redix.pipeline/3` inside a poolboy worker.

      ## Examples

          iex> RedCache.Pool.pipeline([["INCR", "mykey"], ["INCR", "mykey"], ["DECR", "mykey"]])
          {:ok, [1, 2, 1]}

          iex> RedCache.Pool.pipeline([["SET", "k", "foo"], ["INCR", "k"], ["GET", "k"]])
          {:ok, ["OK", %Redix.Error{message: "ERR value is not an integer or out of range"}, "foo"]}
      """
      def pipeline(args, opts \\ []) do
        :poolboy.transaction(
          @pool_name,
          fn worker -> GenServer.call(worker, {:pipeline, args, opts}) end,
          RedCache.Config.get(:timeout, 5000)
        )
      end

      @doc """
      Wrapper to call `Redix.pipeline!/3` inside a poolboy worker, raising if there
      are errors issuing the commands (but not if the commands are successfully
      issued and result in errors).

      ## Examples

          iex> RedCache.Pool.pipeline!([["INCR", "mykey"], ["INCR", "mykey"], ["DECR", "mykey"]])
          [1, 2, 1]

          iex> RedCache.Pool.pipeline!([["SET", "k", "foo"], ["INCR", "k"], ["GET", "k"]])
          ["OK", %Redix.Error{message: "ERR value is not an integer or out of range"}, "foo"]
      """
      def pipeline!(args, opts \\ []) do
        :poolboy.transaction(
          @pool_name,
          fn worker -> GenServer.call(worker, {:pipeline!, args, opts}) end,
          RedCache.Config.get(:timeout, 5000)
        )
      end
    end
  end
end
