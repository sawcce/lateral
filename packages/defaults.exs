defmodule Defaults do
  def section(previous, next) do
    {section_title, rest} = Processor.Utils.parse_atom_forward(next)
    {[{:latex_macro_invocation, [{:atom, section_title}]}], previous, rest}
  end
end

%{section: &Defaults.section/2}
