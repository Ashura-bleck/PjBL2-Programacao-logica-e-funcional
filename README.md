# PjBL2 — Championship Standings in Haskell

Layer 1 defines the shared championship types, match queries, and a sample championship. The code uses the standard `base` library.

## Run the Layer 1 tests

Use GHC from the project root. If you are using the local compiler installed in this workspace, run `export PATH="$PWD/.ghc/bin:$PATH"` first.

```sh
mkdir -p build
ghc -Wall -Werror -hide-all-packages -package base -isrc -outputdir build -o build/testes tests/Testes.hs
./build/testes
```

## Expected results

For `Partida 1 "Athletico" 4 0 "Paraná"`, `participou` returns `True` for Athletico and Paraná and `False` for Maringá. `resultadoPara` returns `Just Vitoria`, `Just Derrota`, and `Nothing` for those teams, respectively. In the 0–0 Coritiba–Operário match, both teams get `Just Empate`.

`times` returns `["Athletico", "Coritiba", "Londrina", "Maringá", "Operário", "Paraná"]` for the sample and `[]` for an empty championship.

[`src/Dados.hs`](src/Dados.hs) provides 15 matches across five rounds, with every team playing once per round. The shared interfaces and proposed tiebreakers are in [the modeling decisions](docs/decisoes.md).
