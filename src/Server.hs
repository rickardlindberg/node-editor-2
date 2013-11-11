{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Map as M

import Data.Maybe
import Data.List
import Data.Ord

import NodeEditor.Data
import NodeEditor.Parser
import NodeEditor.Serialize
import NodeEditor.Writer

import System.ZMQ3.Monadic
import Control.Monad (forever)
import Data.ByteString.Char8 (pack)

main :: IO ()
main = runZMQ $ do
    replySocket <- socket Rep
    bind replySocket "tcp://*:5555"
    initialTree <- liftIO $ loadFile "sandbox"
    serverLoop replySocket initialTree

serverLoop replySocket tree = do
    x <- receive replySocket
    case fromJson x of
        Just GetTopLevelNodes -> do
            send replySocket [] (toJson (topLevelNodes tree))
            serverLoop replySocket tree
        Just (EditBody id body) -> do
            send replySocket [] "{\"status\": true}"
            let newTree = setNodeBody tree id body
            liftIO $ saveFile "sandbox" newTree
            serverLoop replySocket newTree

        _ -> do
            send replySocket [] "{\"status\": false}"
            serverLoop replySocket tree
