module Data where

import qualified Data.Map as M

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

topLevelNodes :: Tree -> [Node]
topLevelNodes (Tree nodes) = M.elems nodes

addNode :: Node -> Tree -> Tree
addNode node (Tree nodes) = Tree (M.insert (nodeId node) node nodes)

getNode :: Int -> Tree -> Node
getNode id (Tree nodes) =
    case (M.lookup id nodes) of
        Just node -> node
        Nothing -> Node 0 "" "default node"

getNextId :: Tree -> Int
getNextId (Tree nodes) = M.size nodes + 1

setNodeBody :: Tree -> Int -> String -> Tree
setNodeBody tree nodeId nodeBody = Tree newNodes
  where
    newNodes = M.alter (swapNodeBody nodeBody) nodeId (nodes tree)


swapNodeBody :: String -> Maybe Node -> Maybe Node
swapNodeBody newBody (Just node) =
  Just $ node { body = newBody }

swapNodeBody body Nothing =
  Nothing
