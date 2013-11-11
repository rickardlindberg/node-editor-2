{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Map as M

import Test.Hspec

import NodeEditor.Data
import NodeEditor.Parser
import NodeEditor.Serialize
import NodeEditor.Writer

main :: IO ()
main = hspec $ do

    describe "Node editor" $ do

        it "can read nodes from file" $ do
            tree <- loadFile "src/Server.hs"
            treeContainsNodeWithBody "import qualified Data.Map as M" tree `shouldBe` True

        it "can read nodes from file" $ do
            tree <- loadFile "src/Server.hs"
            treeContainsNodeWithBody "import qualified Data.Map as M" tree `shouldBe` True

    describe "Modifying nodes" $ do

        it "Can be done." $ do
            let tree = treeFromText "node body"
            let newTree = setNodeBody tree 1 "woho"
            toText newTree `shouldBe` "woho"

        it "actually, for real this time, can be done" $ do
            let tree = treeFromText "node body"
            let newTree = setNodeBody tree 1 "fosho"
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

    describe "lines to tree conversion" $ do

        it "can convert" $ do
            let lines = [ "line one"
                        , ""
                        , "line two"
                        ]
            let tree = linesToTree lines
            treeContainsNodeWithBody "line one" tree `shouldBe` True
            treeContainsNodeWithBody "line two" tree `shouldBe` True

        it "groups lines together that aren't separated by a whitespace"  $ do
            let lines = [ "line one"
                        , "line two"
                        , ""
                        , "line three"
                        ]
            let tree = linesToTree lines

            treeContainsNodeWithBody "line one\nline two" tree `shouldBe` True

        it "doesn't duplicate the additional lines"  $ do
            let lines = [ "line one"
                        , "line two"
                        , ""
                        , "line three"
                        ]
            let tree = linesToTree lines

            treeContainsNodeWithBody "line two" tree `shouldBe` False

        it "Persists additional whitespace properly"  $ do
          let src = "one\n\n\ntwo"
          toText (treeFromText src) `shouldBe` src

    describe "serialization to json" $ do

        it "works for nodes" $ do
            toJson (topLevelNodes $ linesToTree ["line one"])
            `shouldBe`
            "[{\"body\":\"line one\",\"id\":1}]"

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

treeContainsNodeWithBody :: String -> Tree -> Bool
treeContainsNodeWithBody bodyToLookFor (Tree nodes) =
    not $ M.null $ M.filter (\node -> body node == bodyToLookFor) nodes
