{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Map as M

import Test.Hspec

import NodeEditor.Data
import NodeEditor.Parser
import NodeEditor.Serialize
import NodeEditor.Writer

import TestParsingTextIntoATree

main :: IO ()
main = hspec $ do

    parsingTextToTreeSpecs

    describe "Node editor" $ do

        it "can read nodes from file" $ do
            tree <- loadFile "src/Server.hs"
            treeContainsNodeWithBody "import qualified Data.Map as M" tree `shouldBe` True

        it "can read nodes from file" $ do
            tree <- loadFile "src/Server.hs"
            treeContainsNodeWithBody "import qualified Data.Map as M" tree `shouldBe` True

    describe "Modifying nodes" $ do
        it "Can be done" $ do
            let tree = treeFromText "node body"
            let newTree = setNodeBody tree 0 "fosho"
            toText newTree `shouldBe` "fosho"

    describe "Converting a string to text" $ do

        it "Works with a single node!" $ do
            let src = "cd"
            let tree = treeFromText src
            let output = toText tree
            output `shouldBe` src

        it "Works with two nodes!" $ do
            let src = "a\n\ncd"
            let tree = treeFromText src
            let output = toText tree
            output `shouldBe` src

    describe "converting a tree to and from text" $ do
        it "Persists additional whitespace properly"  $ do
          let src = "one\n\n\ntwo"
          toText (treeFromText src) `shouldBe` src

        it "Persists trailing whitespace properly" $ do
          let src = "one\n\n\ntwo\n\n"
          toText (treeFromText src) `shouldBe` src

    describe "serialization to json" $ do

        it "works for nodes" $ do
            toJson (topLevelNodes $ treeFromText "line one")
            `shouldBe`
            "[{\"body\":\"line one\",\"id\":0}]"

    describe "deserialization from json" $ do

        describe "for commands" $ do

            it "top level nodes" $ do
                fromJson "{\"command\":\"get_top_level_nodes\"}"
                `shouldBe`
                Just GetTopLevelNodes

            it "edit body" $ do
                fromJson "{\"command\":\"edit_body\",\"body\":\"hello\",\"id\":1}"
                `shouldBe`
                (Just $ EditBody 1 "hello")
