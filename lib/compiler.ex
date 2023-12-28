defmodule Compiler do
  alias Compiler.Latex
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:latex, nodes}, _from, state) do
    res = Latex.compile(nodes)
    {:reply, res, state}
  end
end
