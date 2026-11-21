module Dados (dadosCampeonato) where

dadosCampeonato :: String
dadosCampeonato = unlines
  [ "# rodada;mandante;gols mandante;gols visitante;visitante"
  , "1;Athletico;4;0;Paraná"
  , "1;Coritiba;0;0;Operário"
  , "1;Londrina;1;2;Maringá"
  , "2;Athletico;1;1;Operário"
  , "2;Paraná;2;0;Maringá"
  , "2;Coritiba;2;0;Londrina"
  , "3;Athletico;2;1;Maringá"
  , "3;Operário;1;0;Londrina"
  , "3;Paraná;1;2;Coritiba"
  , "4;Athletico;0;1;Londrina"
  , "4;Maringá;1;1;Coritiba"
  , "4;Operário;2;1;Paraná"
  , "5;Athletico;1;0;Coritiba"
  , "5;Londrina;0;0;Paraná"
  , "5;Maringá;2;0;Operário"
  ]
