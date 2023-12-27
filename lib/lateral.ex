defmodule Lateral do
  def start(_type, _args) do
    {:ok, pid} =
      Supervisor.start_link([Parser, Lateral.Macros, Processor], strategy: :one_for_one)

    result = GenServer.call(Parser, {:parse, "./examples/test.lat"})
    IO.inspect(result)
    result2 = GenServer.call(Processor, {:process, result}, :infinity)
    IO.inspect(result2)

    {:ok, pid}
  end
end
