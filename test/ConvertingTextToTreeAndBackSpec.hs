module ConvertingTextToTreeAndBackSpec where

import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck
import NodeEditor.Parser
import NodeEditor.Writer

genNodeFileContent :: Gen String
genNodeFileContent = do
  let genBody = return "a static body"
  let genNewlines = fmap concat $ listOf (return "\n")
  bodies <- listOf genBody
  newlines <- vectorOf (length bodies) genNewlines
  let fullText = concat $ zipWith (++) bodies newlines
  return fullText

spec = do
  it "Works with a single node!" $ do
    isRoundtripTheSame "cd" `shouldBe` True

  it "Works with two nodes!" $ do
    isRoundtripTheSame "a\n\ncd" `shouldBe` True

  it "Persists additional whitespace properly"  $ do
    isRoundtripTheSame "one\n\n\ntwo" `shouldBe` True

  it "Persists trailing whitespace properly" $ do
    isRoundtripTheSame "one\n\n\ntwo\n\n" `shouldBe` True

  it "Works for all kinds of input" $ property $
    forAll genNodeFileContent isRoundtripTheSame

isRoundtripTheSame content = toText (treeFromText content) == content
