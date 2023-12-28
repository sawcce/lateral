# Lateral

Lateral is a macro-preprocessor aiming to be extensible and easy to use.
While mainly made to be compiled to tex/LaTeX documents, you can use it to your liking.

## Syntax
Macros are invoked with a bang (!) as such:   
```
use! defaults
```
Anything else is parsed as a token:  
```
Hello, world !
```
Will yield a list of the following tokens: `["Hello,", "world", "!"]`

## Semantics
A macro can consume any tokens behind or after its invocation.  
Let's imagine a macro, `frac!` that consumes one token before and one after its invocation.
```
a frac! b hello, world c frac! d
```

Here, the first invocation will consume both a and b, the second c and d, "hello, world" will be yield as a text node as it hasn't been consumed.  
But, what if I wanted to consume a group of tokens rather than tokens individually?  (introducing atoms)

### Atoms
Atoms are a collection of tokens delimited by specific characters, lateral only recognizes as separate tokens `{},(),[]` as separate tokens; hence it is not recommended to use other delimiters as it would be much harder to implement and error prone (this might change in the future to make the language more customizable).

An atom might look like this: 
```
{Hello, world}
(test, test, test)
(hey !)
[this, is, a, list?]
```
Keep in mind that these are purely covnetions and you are free to manipulate tokens to your liking; it'd just be much harder to process such an atom `##Hello, world##` as you would only be able to process this: `[{:token "##Hello,"}, {:token, "world##"}]`  
## A simple LaTeX document

You can tailor documents to various preferences using Lateral, with the flexibility to create different document flavors. Note that while options requiring packages are not yet implemented, the following serves as a showcase.
### One to one
```
use!(latex, flavour: one-to-one)
documentclass!(article)

begin! document
section!{Introduction to Lateral}

Lateral is a macro-preprocessor designed for LaTeX documents. It offers extensibility and ease of use, allowing users to create customized macros to process tokens.

subsection!{Features}
begin! itemize
  item! Extensibility
  item! Easy to use
  item! Token parsing
end! itemize
end! document
```

### Encased
```
use!(latex, flavour: encased)
documentclass!(article)

document!(
section!{Introduction to Lateral}

  Lateral is a macro-preprocessor designed for LaTeX documents. It offers extensibility and ease of use, allowing users to create customized macros to process tokens.

  subsection!{Features}
  itemize!(
    item! Extensibility
    item! Easy to use
    item! Token parsing
  )itemize
)document
```


### XML-like (W.I.P)
```xml
use!(latexml)
documentclass!(article)

document!
<section title="Introduction to Lateral">
  Lateral is a macro-preprocessor designed for LaTeX documents. It offers extensibility and ease of use, allowing users to create customized macros to process tokens.

  <subsection title="features">
    <item>Extensibility</item>
    <item>Easy to use</item>
    <item>Token parsing</item>
  </subsection>
</section>
```

## Verdict
Apart from the last one which will require some rework on the parsing (as I would like for that kind of freedom to be achievable), you can make your own lateral macros to achieve a LaTeX document that will reflect your intent or use the ones that are being worked on. The aim of the project is for individuals to be able to have a tailored environment to take notes, write and work in.

# Contribute
Feel free to fork and make PRs to help with this project!