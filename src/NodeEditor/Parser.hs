module NodeEditor.Parser where

import Data.List

import NodeEditor.Data

dropNonEmptyChunk :: [String] -> [String]
dropNonEmptyChunk lines =
  dropWhile (\line -> not (null line)) lines

dropEmptyLines :: [String] -> [String]
dropEmptyLines lines =
  dropWhile (\line -> null line) lines

linesToTree :: [String] -> Tree
linesToTree [] = emptyTree
linesToTree (lines) =
    let (nodeBody, restLines) = extractBodyFromList(lines)
        restTree = linesToTree restLines
    in
        addNode (Node (getNextId restTree) "" nodeBody) restTree

extractBodyFromList :: [String] -> (String, [String])
extractBodyFromList lines =
  let bodyLines = (takeWhile (\line -> not $ null line) lines)
  in
    ((intercalate "\n" bodyLines), (dropEmptyLines (dropNonEmptyChunk lines)))

treeFromText :: String -> Tree
treeFromText text =
    linesToTree (lines text)

loadFile :: FilePath -> IO Tree
loadFile path = do
    contents <- readFile path
    return $ treeFromText contents

