import Html

open Doc Doc.Html Doc.Jsx

def test : Html := <h1>Test</h1>


def sayHello (s: String): Html :=
  <div>Hello {s ++ "!"} {test}</div>

def main (args : List String) : IO UInt32 := do
  try
    IO.println <| Html.toString <| sayHello "world"
    pure 0
  catch e =>
    IO.eprintln <| "error: " ++ e.toString -- avoid "uncaught exception: ..."
    pure 1

