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

getNode :: Int -> Tree -> Node
getNode id (Tree nodes) =
    case (M.lookup id nodes) of
        Just node -> node
        Nothing -> Node 0 "" ""

addNode :: Node -> Tree -> Tree
addNode node (Tree nodes) = Tree (M.insert (nodeId node) node nodes)

loadFile :: FilePath -> IO Tree
loadFile path = return
              $ addNode (Node 2 "" "import qualified Data.Map as M")
              $ addNode (Node 1 "" "module NodeEditor where")
              $ emptyTree
