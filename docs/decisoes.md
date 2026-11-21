# Modeling decisions and integration contracts

`Time` is a case-sensitive team name. `Partida` uses named fields to keep the two scores distinct, and `Resultado` limits outcomes to `Vitoria`, `Empate`, and `Derrota`. `resultadoPara` returns `Nothing` for teams outside the match. `times` uses the standard `String` ordering.

`Linha` stores `time`, `jogos`, `vitorias`, `empates`, `derrotas`, `golsPro`, and `golsContra`. Classification derives points and goal difference from these totals so they cannot conflict with stored values.

`Dados` exports `dadosCampeonato :: String`. Each match uses the field order `round;home team;home goals;away goals;away team`. Consumers skip blank lines and lines beginning with `#`. The records use `Int` for round and goal counts. The reading layer validates textual input and the schedule before classification.

## Proposed ranking rules for group agreement

Award three points for a win, one for a draw, and zero for a loss. Sort by points, then goal difference, then goals scored, all descending. If those values match, sort by team name in ascending order for a deterministic result.

In the sample, Coritiba and Operário both finish with eight points. Coritiba ranks ahead on goal difference (+2 versus 0). Londrina and Paraná both finish with four points. Londrina ranks ahead on goal difference (−3 versus −4).

## Layer 2 interface for `Classificacao.hs`

```haskell
pontos :: Resultado -> Int
linhaDoTime :: [Partida] -> Time -> Linha
pontosLinha :: Linha -> Int
saldo :: Linha -> Int
aproveitamento :: Linha -> Double
classificacao :: [Partida] -> [Linha]
ateRodada :: Int -> [Partida] -> [Partida]
maiorGoleada :: [Partida] -> Maybe Partida
mediaGols :: [Partida] -> Maybe Double
```

## Layer 3 interface for `Leitura.hs` and `Main.hs`

`Leitura` defines `Erro` with at least `CamposInvalidos`, `NumeroInvalido`, `PlacarNegativo`, `MesmoTime`, and `TimeRepetidoNaRodada`. Each error identifies the offending input line or round.

```haskell
separar :: Char -> String -> [String]
lerPartida :: Int -> String -> Either Erro Partida
lerCampeonato :: String -> Either Erro [Partida]
todosOsErros :: String -> [Erro]
tabelaFormatada :: [Linha] -> String
```

`Main` provides `main :: IO ()` and passes `dadosCampeonato` to `lerCampeonato` before producing output.
