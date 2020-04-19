module Main where

import Simulation (run)
import Data.List
import Control.Monad (mapM_)

main = do
  dat <- run
  return ()
  -- mapM_ (\(x, y) -> putStrLn $ intercalate "  " [show x, show y]) dat
