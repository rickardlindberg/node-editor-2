import qualified Data.Map as M

import Test.Hspec

import NodeEditor

main :: IO ()
main = hspec $ do

    describe "Node editor" $ do

        it "can read nodes from file" $ do
            tree <- loadFile "NodeEditor.hs"
            treeContainsNodeWithBody "module NodeEditor where" tree `shouldBe` True

        it "can read nodes from file" $ do
            tree <- loadFile "NodeEditor.hs"
            treeContainsNodeWithBody "import qualified Data.Map as M" tree `shouldBe` True

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

treeContainsNodeWithBody :: String -> Tree -> Bool
treeContainsNodeWithBody bodyToLookFor (Tree nodes) =
    not $ M.null $ M.filter (\node -> body node == bodyToLookFor) nodes
