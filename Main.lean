import «Html»

open Doc Doc.Html Doc.Jsx

def test : Html := <h1>Test</h1>

def main : IO Unit :=
  IO.println test.toString
