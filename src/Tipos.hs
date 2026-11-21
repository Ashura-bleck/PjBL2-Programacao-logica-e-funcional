module Tipos
  ( Time
  , Resultado (..)
  , Partida (..)
  , Linha (..)
  , participou
  , resultadoPara
  , times
  ) where

import Data.List (nub, sort)

type Time = String

data Resultado = Vitoria | Empate | Derrota
  deriving (Show, Eq)

data Partida = Partida
  { rodada :: Int
  , mandante :: Time
  , golsMandante :: Int
  , golsVisitante :: Int
  , visitante :: Time
  } deriving (Show, Eq)

data Linha = Linha
  { time :: Time
  , jogos :: Int
  , vitorias :: Int
  , empates :: Int
  , derrotas :: Int
  , golsPro :: Int
  , golsContra :: Int
  } deriving (Show, Eq)

participou :: Time -> Partida -> Bool
participou nome partida = nome == mandante partida || nome == visitante partida

resultadoPara :: Time -> Partida -> Maybe Resultado
resultadoPara nome partida
  | nome == mandante partida = Just (compararPlacar golsCasa golsFora)
  | nome == visitante partida = Just (compararPlacar golsFora golsCasa)
  | otherwise = Nothing
  where
    golsCasa = golsMandante partida
    golsFora = golsVisitante partida

compararPlacar :: Int -> Int -> Resultado
compararPlacar golsFeitos golsSofridos = case compare golsFeitos golsSofridos of
  GT -> Vitoria
  EQ -> Empate
  LT -> Derrota

times :: [Partida] -> [Time]
times = sort . nub . concatMap (\partida -> [mandante partida, visitante partida])
