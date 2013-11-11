{-# LANGUAGE OverloadedStrings #-}

module NodeEditor where

import qualified Data.Map as M

import Data
import Data.Maybe
import Data.List
import Data.Ord

import Parser
import Writer
import Serialize

import System.ZMQ3.Monadic
import Control.Monad (forever)
import Data.ByteString.Char8 (pack)

main :: IO ()
main = runZMQ $ do
    rep <- socket Rep
    bind rep "tcp://*:5555"
    forever $ do
        x <- receive rep
        send rep [] (toJson (topLevelNodes $ linesToTree ["line one"]))
