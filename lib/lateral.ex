defmodule Lateral do
  def start(_type, _args) do
    {:ok, pid} =
      Supervisor.start_link([Parser, Lateral.Macros, Processor, Compiler], strategy: :one_for_one)

    config = :filename.basedir(:user_config, "lateral")
    if !File.exists?(config) do
      File.mkdir(config)
      File.mkdir(Path.join(config, "packages"))
    end

    result = GenServer.call(Parser, {:parse, "./examples/test.lat"})
    IO.inspect(result)
    result2 = GenServer.call(Processor, {:process, result}, :infinity)
    IO.inspect(result2)
    result3 = GenServer.call(Compiler, {:latex, result2})
    File.write("examples/test.tex", result3)
    IO.inspect(result3)

    {:ok, pid}
  end
end
