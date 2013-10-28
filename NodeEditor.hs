module NodeEditor where

import qualified Data.Map as M

import Data.List

data Node = Node
    { nodeId :: Int
    , title :: String
    , body :: String
    } deriving (Show)

data Tree = Tree
    { nodes :: M.Map Int Node
    } deriving (Show)

emptyTree :: Tree
emptyTree = Tree M.empty

getNode :: Int -> Tree -> Node
getNode id (Tree nodes) =
    case (M.lookup id nodes) of
        Just node -> node
        Nothing -> Node 0 "" "default node"

addNode :: Node -> Tree -> Tree
addNode node (Tree nodes) = Tree (M.insert (nodeId node) node nodes)

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

dropNonEmptyChunk :: [String] -> [String]
dropNonEmptyChunk lines =
  dropWhile (\line -> not (null line)) lines

dropEmptyLines :: [String] -> [String]
dropEmptyLines lines =
  dropWhile (\line -> null line) lines

getNextId :: Tree -> Int
getNextId (Tree nodes) = M.size nodes + 1

loadFile :: FilePath -> IO Tree
loadFile path = do
    contents <- readFile path
    return $ linesToTree (lines contents)
