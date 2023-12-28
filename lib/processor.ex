defmodule Processor do
  alias Lateral.Macros
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__, timeout: :infinity)
  end

  def init(_init_arg) do
    {:ok, nil}
  end

  def macro_invocation(macro, previous, tokens) do
    if !is_list(tokens) do
      GenServer.call(Macros, {macro, previous, [tokens]})
    else
      GenServer.call(Macros, {macro, previous, tokens})
    end
  end

  def reduce(text) do
    Enum.reduce(text, "", fn token, acc ->
      acc <>
        " " <>
        case token do
          {:token, token} -> token
          :lbrace -> "{"
          :rbrace -> "}"
          :lbrack -> "["
          :rbrack -> "]"
        end
    end)
  end

  def process(generated, previous, []) do
    generated ++ [{:text, reduce(previous)}]
  end

  def process(generated, previous, [first_token | tokens]) do
    case first_token do
      {:macro_invocation, macro} ->
        {newly_generated, previous, tokens} = macro_invocation(macro, previous, tokens)

        reduced_text = reduce(previous)

        process(
          generated ++
            if(reduced_text == "", do: [], else: [{:text, reduced_text}]) ++
            newly_generated,
          [],
          tokens
        )

      x ->
        process(generated, previous ++ [x], tokens)
    end
  end

  def handle_call({:process, tokens}, from, state) do
    res = process([], [], tokens)
    {:reply, res, state}
  end
end

defmodule Processor.Utils do
  def process(tokens) do
    Processor.process([], [], tokens)
  end

  def parse_atom_forward(tokens) do
    next = List.first(tokens)

    if next != :lbrace do
      {:error, "expected left brace!"}
    else
      {_, rest} = List.pop_at(tokens, 0)
      parse_atom_forward([], rest, 1)
    end
  end

  def parse_atom_forward(parsed, tokens, 0) do
    {parsed, tokens}
  end

  def parse_atom_forward(parsed, tokens, nest_level) do
    {next, rest} = List.pop_at(tokens, 0)

    case next do
      :lbrace ->
        parse_atom_forward(parsed ++ [:lbrace], rest, nest_level + 1)

      :rbrace ->
        if nest_level == 1,
          do: {parsed, rest},
          else: parse_atom_forward(parsed ++ [:rbrace], rest, nest_level - 1)

      x ->
        parse_atom_forward(parsed ++ [x], rest, nest_level)
    end
  end
end
