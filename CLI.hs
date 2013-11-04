import NodeEditor
import qualified Data.Map as M
import Data.Maybe

loadTree :: IO Tree
loadTree = loadFile "NodeEditor.hs"

printIds :: IO ()
printIds = do
    tree <- loadTree
    putStrLn $ show (M.keys $ nodes tree)

printBody :: Int -> IO ()
printBody id = do
    tree <- loadTree
    putStrLn $ body $ fromJust $ M.lookup id $ nodes tree
