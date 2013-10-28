import Test.Hspec

import NodeEditor

main :: IO ()
main = hspec $ do

    describe "Node editor" $ do
        it "can read nodes from file" $ do
            tree <- loadFile "NodeEditor.hs"
            (body (getNode 1 tree)) `shouldBe` "module NodeEditor where"
