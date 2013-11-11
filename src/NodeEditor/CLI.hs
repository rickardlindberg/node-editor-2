{-# LANGUAGE BangPatterns #-}

module NodeEditor.CLI where

import NodeEditor

import qualified Data.Map as M

import Data
import Data.Maybe

import Parser
import Writer


loadTree :: IO Tree
loadTree = loadFile "sandbox"

printIds :: IO ()
printIds = do
    tree <- loadTree
    putStrLn $ show (M.keys $ nodes tree)

modifyBody :: Int -> String -> IO ()
modifyBody id newBody = do
    !tree <- loadTree
    let newTree = setNodeBody tree id newBody in
      saveFile "sandbox" newTree

printBody :: Int -> IO ()
printBody id = do
    tree <- loadTree
    putStrLn $ body $ fromJust $ M.lookup id $ nodes tree
