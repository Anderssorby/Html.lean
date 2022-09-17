import Html

open Doc.Html

def sayHello (s: String): Html :=
  <div>{"Hello " ++ s}</div>

def main (args : List String) : IO UInt32 := do
  try
    println! <| sayHello "world"
    pure 0
  catch e =>
    IO.eprintln <| "error: " ++ toString e -- avoid "uncaught exception: ..."
    pure 1

