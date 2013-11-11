{-# LANGUAGE OverloadedStrings #-}

module Serialize where

import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.ByteString.Char8 as B

import Data.Aeson

import Data

instance ToJSON Node where
    toJSON node = object [ "id" .= nodeId node
                         , "body" .= body node
                         ]

toJson :: [Node] -> B.ByteString
toJson = B.concat . BL.toChunks . encode
