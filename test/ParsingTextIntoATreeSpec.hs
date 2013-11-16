module ParsingTextIntoATreeSpec where

import Test.Hspec

import NodeEditor.Data
import NodeEditor.Parser

import Data.List.Split

import qualified Data.Map as M

spec = do
  describe "Parsing Text into a Tree" $ do
    it "can parse a single line into a tree" $ do
      let tree = parseTextToTree "foo"
      treeContainsNodeWithBody "foo" tree `shouldBe` True

    it "can parse multiple lines into a tree" $ do
      let tree = parseTextToTree "foo\n\nbar\n\n"
      treeContainsNodeWithBody "foo" tree `shouldBe` True
      treeContainsNodeWithBody "bar" tree `shouldBe` True
