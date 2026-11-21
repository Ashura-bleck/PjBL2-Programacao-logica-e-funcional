module Main (main) where

import Data.List (nub, sort)
import Dados (dadosCampeonato)
import Text.Read (readMaybe)
import Tipos

main :: IO ()
main = do
  let partida = Partida 1 "Athletico" 4 0 "Paraná"
      empate = Partida 1 "Coritiba" 0 0 "Operário"
  testar "participação de mandante, visitante e time ausente"
    (map (`participou` partida) ["Athletico", "Paraná", "Maringá"])
    [True, True, False]
  testar "resultado de mandante, visitante e time ausente"
    (map (`resultadoPara` partida) ["Athletico", "Paraná", "Maringá"])
    [Just Vitoria, Just Derrota, Nothing]
  testar "vitória do visitante"
    (resultadoPara "Londrina" (Partida 4 "Athletico" 0 1 "Londrina"))
    (Just Vitoria)
  testar "empate para os dois times"
    (map (`resultadoPara` empate) ["Coritiba", "Operário"])
    [Just Empate, Just Empate]
  testar "times de campeonato vazio" (times []) []
  testar "times de partidas repetidas em ordem alfabética"
    (times [empate, partida, partida]) ["Athletico", "Coritiba", "Operário", "Paraná"]
  case traverse lerPartidaDeTeste (filter linhaDePartida (lines dadosCampeonato)) of
    Nothing -> ioError (userError "Formato inválido nos dados do campeonato")
    Just partidas -> testarCampeonato partidas
  putStrLn "Todos os testes da Camada 1 passaram."

testarCampeonato :: [Partida] -> IO ()
testarCampeonato partidas = do
  let nomes = times partidas
      rodadas = sort (nub (map rodada partidas))
      presencas = concatMap (\p -> [(rodada p, mandante p), (rodada p, visitante p)]) partidas
      confrontos = map (\p -> sort [mandante p, visitante p]) partidas
  testar "times distintos em ordem alfabética" nomes
    ["Athletico", "Coritiba", "Londrina", "Maringá", "Operário", "Paraná"]
  testar "cinco rodadas" rodadas [1, 2, 3, 4, 5]
  testar "quinze confrontos distintos" (length (nub confrontos)) 15
  testar "uma partida por time a cada rodada" (sort presencas)
    [(r, time) | r <- rodadas, time <- nomes]
  testar "placares válidos" (all (\p -> golsMandante p >= 0 && golsVisitante p >= 0) partidas) True
  testar "empate em 0 × 0" (any (\p -> golsMandante p == 0 && golsVisitante p == 0) partidas) True
  testar "goleada por três ou mais gols"
    (any (\p -> abs (golsMandante p - golsVisitante p) >= 3) partidas) True
  testar "Coritiba e Operário empatam em pontos"
    (map (`pontosDeTeste` partidas) ["Coritiba", "Operário"]) [8, 8]
  testar "Coritiba tem saldo maior que Operário"
    (map (`saldoDeTeste` partidas) ["Coritiba", "Operário"]) [2, 0]

testar :: (Eq a, Show a) => String -> a -> a -> IO ()
testar nome obtido esperado
  | obtido == esperado = putStrLn ("OK " ++ nome)
  | otherwise = ioError (userError (nome ++ " | esperado " ++ show esperado ++ ", obtido " ++ show obtido))

linhaDePartida :: String -> Bool
linhaDePartida [] = False
linhaDePartida ('#' : _) = False
linhaDePartida _ = True

lerPartidaDeTeste :: String -> Maybe Partida
lerPartidaDeTeste linha = case campos linha of
  [r, casa, golsCasa, golsFora, fora] ->
    Partida <$> readMaybe r <*> pure casa <*> readMaybe golsCasa <*> readMaybe golsFora <*> pure fora
  _ -> Nothing
  where
    campos texto = case break (== ';') texto of
      (campo, []) -> [campo]
      (campo, _ : resto) -> campo : campos resto

pontosDeTeste :: Time -> [Partida] -> Int
pontosDeTeste time partidas =
  3 * length (filter (== Just Vitoria) resultados) + length (filter (== Just Empate) resultados)
  where
    resultados = map (resultadoPara time) partidas

saldoDeTeste :: Time -> [Partida] -> Int
saldoDeTeste time partidas =
  sum [diferenca p | p <- partidas, mandante p == time]
    - sum [diferenca p | p <- partidas, visitante p == time]
  where
    diferenca p = golsMandante p - golsVisitante p
