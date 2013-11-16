module WorkingWithTheFileSystemSpec where

import NodeEditor.Parser
import NodeEditor.Data

import Test.Hspec
spec = do
  describe "Reading from the file system" $ do
    it "can read nodes from file" $ do
      tree <- loadFile "src/Server.hs"
      treeContainsNodeWithBody "import qualified Data.Map as M" tree `shouldBe` True
