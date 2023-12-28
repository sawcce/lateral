defmodule Defaults do
  def section(previous, next) do
    {section_title, rest} = Processor.Utils.parse_atom_forward(next)
    t =  Processor.Utils.process(section_title)
    {[{:tex_macro_invocation, "section", [{:atom, t}]}], previous, rest}
  end

  def class(previous, tokens) do
    {{:token, document_class}, rest} = List.pop_at(tokens, 0)

    {[{:tex_macro_invocation, "documentclass", [{:atom, document_class}]}], previous, rest}
  end

  def begin(previous, tokens) do
    {{:token, environment}, rest} = List.pop_at(tokens, 0)

    IO.puts("begin env: #{environment}")

    {[{:tex_macro_invocation, "begin", [{:atom, environment}]}], previous, rest}
  end

  def end_(previous, tokens) do
    {{:token, environment}, rest} = List.pop_at(tokens, 0)

    {[{:tex_macro_invocation, "end", [{:atom, environment}]}], previous, rest}
  end
end

%{class: &Defaults.class/2, section: &Defaults.section/2, begin: &Defaults.begin/2, end: &Defaults.end_/2}
