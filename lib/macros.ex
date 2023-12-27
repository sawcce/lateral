defmodule Lateral.Macros do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__, timeout: :infinity)
  end

  @impl true
  def init(_init_arg) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({"begin", previous, tokens}, _from, state) do
    IO.inspect(state)
    {{:token, environment}, rest} = List.pop_at(tokens, 0)

    IO.puts("begin env: #{environment}")

    {:reply, {[{:new_environment, environment}], previous, rest}, state}
  end

  @impl true
  def handle_call({"end", previous, tokens}, _from, state) do
    {{:token, environment}, rest} = List.pop_at(tokens, 0)
    # {last_environment, others} = List.pop_at(state, 0)

    {:reply, {[{:close_environment, environment}], previous, rest}, state}
  end

  @impl true
  def handle_call({"use", previous, tokens}, _from, state) do
    {{:token, package}, rest} = List.pop_at(tokens, 0)

    {exports, _} = Code.eval_file("./packages/#{package}.exs")
    IO.inspect exports

    IO.puts("Use: #{package}")
    {:reply, {[], previous, rest}, Map.merge(state, exports)}
  end

  @impl true

  def handle_call({arbitrary_macro, previous, tokens}, _from, state) do
    IO.puts("Macro: #{arbitrary_macro}, #{inspect state}")
    macro = Map.get(state, String.to_existing_atom(arbitrary_macro))
    if macro == nil do
      IO.puts "UNKNOWN MACRO: #{arbitrary_macro}"
      {:reply, {[], previous, tokens}, state}
    else
      res = apply(macro, [previous, tokens])
      IO.puts "Res: #{inspect res}"
      {:reply, res, state}
    end

  end
end
