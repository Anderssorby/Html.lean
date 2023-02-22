import Lake
open Lake DSL

package «html» {
  -- add package configuration options here
}

lean_lib «Html» {
  -- add library configuration options here
  srcDir := "src"
}

@[default_target]
lean_exe «html» {
  root := `Main
}

lean_exe test {
  root := `test.Tests
}

