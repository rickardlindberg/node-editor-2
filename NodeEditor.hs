module NodeEditor where

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

addNode :: Node -> Tree -> Tree
addNode node (Tree nodes) = Tree (M.insert (nodeId node) node nodes)

main = do
    let foo = Node 1 "foo" "I am the foo node"
    let bar = Node 2 "bar" "I am the bar node"
    let tree = addNode bar $ addNode foo $ emptyTree
    print tree
