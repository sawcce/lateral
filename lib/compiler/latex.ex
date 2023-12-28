defmodule Compiler.Latex do
  @spec compile(list()) :: String.t()
  def compile(nodes) when is_list(nodes) do
    Enum.reduce(nodes, "", fn node, acc ->
      acc <>
        case node do
          {:use_unknown, package} -> "\\usepackage{#{package}}\n"
          {:tex_macro_invocation, macro, args} -> macro_invocation(macro, args)
          {:text, text} -> " " <> text <> " "
        end
    end)
  end

  @spec compile(String.t()) :: String.t()
  def compile(string) do
    string
  end

  @spec macro_invocation(String.t(), list()) :: String.t()
  def macro_invocation(name, args) do
    if(name in ["begin", "end", "section"],
      do: "\n",
      else: ""
    ) <>
      "\\" <>
      name <>
      Enum.reduce(args, "", fn arg, acc ->
        case arg do
          {:atom, contents} ->
            acc <> "{" <> compile(contents) <> "}"

          x ->
            IO.puts("Uknown data structure in call to #{name}: #{inspect(x)}")
            acc
        end
      end)
  end
end
