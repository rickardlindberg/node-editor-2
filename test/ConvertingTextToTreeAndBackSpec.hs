module ConvertingTextToTreeAndBackSpec where

import Test.Hspec
import NodeEditor.Parser
import NodeEditor.Writer

spec = do
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

  it "Persists additional whitespace properly"  $ do
    let src = "one\n\n\ntwo"
    toText (treeFromText src) `shouldBe` src

  it "Persists trailing whitespace properly" $ do
    let src = "one\n\n\ntwo\n\n"
    toText (treeFromText src) `shouldBe` src
