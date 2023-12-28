defmodule Parser do
  use GenServer

  def start_link(_default) do
    GenServer.start_link(__MODULE__, :idle, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    {:ok, :idle}
  end

  def parse_guarded(newly_constructed, constructed, tokens) do
    if newly_constructed == {:token, ""} do
      parse(constructed, "", tokens)
    else
      parse(constructed ++ [newly_constructed], "", tokens)
    end
  end

  def parse_guarded(newly_constructed, last_group, constructed, tokens) do
    if last_group == "" do
      parse(constructed ++ [newly_constructed], "", tokens)
    else
      parse(constructed ++ [{:token, last_group}, newly_constructed], "", tokens)
    end
  end



  def parse(constructed, last_group, token) when length(token) <= 1 do
    case token do
      [token] ->
        constructed ++ {:token, last_group <> token}

      [] ->
        constructed
    end
  end

  def parse(constructed, last_group, [next_token | tokens]) do
    case next_token do
      "!" when last_group != "" ->
        parse(constructed ++ [{:macro_invocation, last_group}], "", tokens)

      "{" -> parse_guarded(:lbrace, last_group, constructed, tokens)
      "}" -> parse_guarded(:rbrace, last_group, constructed, tokens)

      "[" -> parse_guarded(:lbrack, last_group, constructed, tokens)
      "]" -> parse_guarded(:rbrack, last_group, constructed, tokens)

      x ->
        if String.trim(x) == "" do
          parse_guarded({:token, last_group}, constructed, tokens)
        else
          parse(constructed, last_group <> next_token, tokens)
        end
    end
  end

  def parse(codepoints) do
    [head | tail] = codepoints
    parse([], head, tail)
  end

  @impl true
  def handle_call({:parse, path}, _from, state) do
    {:ok, document} = File.read(path)

    parsed = document |> String.codepoints() |> parse
    File.write(path <> ".out", (inspect parsed) |> String.replace(~r"({| :)", fn a -> "\n"<>a end))

    {:reply, parsed, :idle}
  end
end
