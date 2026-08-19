defmodule Workspace.WasmWorker do
  @moduledoc """
  Popcorn demo entrypoint, compiled to WebAssembly and run client-side via:

      mix popcorn.cook --start-module Workspace.WasmWorker

  Deliberately excluded from `Workspace.Application`'s supervision tree —
  the Phoenix Endpoint (Bandit's TCP listener) and the Ecto/SQLite Repo
  can't run inside the WASM sandbox, so this worker boots independently
  instead of piggybacking on the normal `mix phx.server` startup path.
  """

  use GenServer

  @process_name :wasm_worker

  @doc "Popcorn's WASM boot entrypoint, called after OTP applications start."
  def start do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: @process_name)
    :ok
  end

  @impl true
  def init(_init_arg) do
    Popcorn.Wasm.ready(@process_name)
    IO.puts("Hello from WASM!")
    {:ok, %{}}
  end
end
