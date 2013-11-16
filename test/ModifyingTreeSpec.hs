module ModifyingTreeSpec where

import Test.Hspec

import NodeEditor.Data
import NodeEditor.Parser

spec = do
  describe "setNodeBody" $ do
    it "replaces the node body for the given id" $ do
      let tree = treeFromText "node body"
      let newTree = setNodeBody tree 0 "fosho"
      getNodeBody newTree 0 `shouldBe` "fosho"
