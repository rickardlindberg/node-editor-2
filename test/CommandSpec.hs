{-# LANGUAGE OverloadedStrings #-}

module CommandSpec where

import NodeEditor.Serialize

import Test.Hspec

spec = do
  describe "Deserializing commands from JSON" $ do
    it "deserializes get_top_level_nodes to GetTopLevelNodes" $ do
      fromJson "{\"command\":\"get_top_level_nodes\"}"
      `shouldBe`
      Just GetTopLevelNodes

    it "deserializes edit_body to EditBody with the id and body text" $ do
      fromJson "{\"command\":\"edit_body\",\"body\":\"hello\",\"id\":1}"
      `shouldBe`
      (Just $ EditBody 1 "hello")

