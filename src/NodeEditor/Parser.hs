module NodeEditor.Parser where

import Data.List
import Data.List.Split

import NodeEditor.Data

treeFromText :: String -> Tree
treeFromText text =
    parseTextToTree text

loadFile :: FilePath -> IO Tree
loadFile path = do
    contents <- readFile path
    return $ treeFromText contents

parseTextToTree :: String -> Tree
parseTextToTree textOfTree =
  let nodeBodies = splitOn "\n\n" textOfTree
  in addNodeBodies nodeBodies
  where
    addNodeBodies :: [String] -> Tree
    addNodeBodies [] = emptyTree
    addNodeBodies (body:restBodies) = addNode (Node (length restBodies) "" body)
                                              (addNodeBodies restBodies)

