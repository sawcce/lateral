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
But, what if I wanted to consume a group of tokens rather than tokens individually?  
To do that you can do whatever you want to define a group of tokens, but, beware only: `()[]{}`  are recognized as separate tokens. Hence, you could make your macro parse what we'd call an atom: `(n fact!) frac! { (n-k) fact! n fact! }`. They are purely conventions and you are free to use any kind of delimiter.