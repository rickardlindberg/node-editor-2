{-# LANGUAGE OverloadedStrings #-}

module SerializingTreesToJsonSpec where

import Test.Hspec

import NodeEditor.Data
import NodeEditor.Serialize
import NodeEditor.Parser

spec = do
  it "works for nodes" $ do
    toJson (topLevelNodes $ treeFromText "line one")
    `shouldBe`
    "[{\"body\":\"line one\",\"id\":0}]"
