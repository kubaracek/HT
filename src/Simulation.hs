module Simulation (run, trash) where

import Types --(Customer, Establishment(Bank))
import Math (inverse, betaDistribution)
import System.Random (randomRIO)
import Data.Conduit -- (ConduitT, yield, (.|), runConduitRes)
import qualified Data.Conduit.Combinators as C


import Control.Monad (forever)
import Control.Monad.IO.Class (liftIO)

randomStream :: (Double, Double) -> Source IO Double
randomStream range = forever $ liftIO (randomRIO range) >>= yield

run = do
  model <- runConduit
     $ randomStream (0.0,1.0)
    .| C.map (\r -> (r, inverse Bank r))
    .| C.map (\(r, a) -> (a, modelDistributions r))
    -- .| C.foldp foldTimeSeries
    .| C.take 100000
    .| C.sinkList

  return model
  where
    foldTimeSeries :: (Double, Double) -> [TimeSeries] -> [TimeSeries]
    foldTimeSeries (arrival, processing) acc@(h:_) =
      let
        waitingCalc = tProcessing h - arrival
        waitingFn =
          if waitingCalc < 0 then
            0
          else
            waitingCalc
      in
      TimeSeries arrival processing waitingFn : acc
    modelDistributions r =
      (\[r,y,b] -> (r,y,b))
        $ map (\x -> betaDistribution x r)  [Red, Yellow, Blue]


trash = do
  dat <- run
  return ()
