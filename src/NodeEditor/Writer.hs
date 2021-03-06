module NodeEditor.Writer where

import Data.List
import qualified Data.Map as M

import NodeEditor.Data

toText :: Tree -> String
toText tree =
  let nodeMap = nodes tree
      bodies = M.map (\node -> body node) nodeMap
  in intercalate "\n\n" $ map snd $ reverse $ M.toList bodies

saveFile :: FilePath -> Tree -> IO ()
saveFile path tree = do
  writeFile path (toText tree)



