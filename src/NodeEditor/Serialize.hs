{-# LANGUAGE OverloadedStrings #-}

module NodeEditor.Serialize where

import Control.Applicative
import Control.Monad
import Data.Functor
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Lazy.Char8 as BL

import Data.Aeson

import NodeEditor.Data

data Command = GetTopLevelNodes | EditBody Int String
    deriving (Show, Eq)

instance ToJSON Node where
    toJSON node = object [ "id" .= nodeId node
                         , "body" .= body node
                         ]

instance FromJSON Command where
    parseJSON (Object v) = do
                            command <- v .: "command"
                            case (command :: String) of
                                "get_top_level_nodes" -> return GetTopLevelNodes
                                "edit_body" -> EditBody <$> v .: "id" <*> v .: "body"
                                _ -> mzero
    parseJSON _ = mzero

toJson :: [Node] -> B.ByteString
toJson = B.concat . BL.toChunks . encode

fromJson :: B.ByteString -> Maybe Command
fromJson = decode . BL.fromChunks . (:[])
