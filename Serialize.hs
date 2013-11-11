{-# LANGUAGE OverloadedStrings #-}

module Serialize where

import qualified Data.ByteString.Lazy.Char8 as BL

import Data.Aeson

import Data

instance ToJSON Node where
    toJSON node = object [ "id" .= nodeId node
                         , "body" .= body node
                         ]

toJson :: [Node] -> BL.ByteString
toJson nodes = encode nodes
