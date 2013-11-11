module NodeEditor.Parser where

import Data.List

import NodeEditor.Data


linesToTree :: [String] -> Tree
linesToTree [] = emptyTree
linesToTree (lines) =
    let (nodeBody, restLines) = extractBodyFromList(lines)
        restTree = linesToTree restLines
    in
        addNode (Node (getNextId restTree) "" nodeBody) restTree

extractBodyFromList :: [String] -> (String, [String])
extractBodyFromList lines =
  let
      (nodePrefix, potentialNodeContent) = extractAsLongAs null lines
      (nodeContent, remainderOfList) = extractAsLongAs (not . null) potentialNodeContent
      fullNodeBody = nodePrefix ++ nodeContent
      startOfNextBody = drop 1 remainderOfList
  in
    (intercalate "\n" fullNodeBody, startOfNextBody)

extractAsLongAs :: (a -> Bool) -> [a] -> ([a], [a])
extractAsLongAs condition list = (takeWhile condition list, dropWhile condition list)

treeFromText :: String -> Tree
treeFromText text =
    linesToTree (lines text)

loadFile :: FilePath -> IO Tree
loadFile path = do
    contents <- readFile path
    return $ treeFromText contents

