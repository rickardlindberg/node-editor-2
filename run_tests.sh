#!/bin/sh
ghc --make -itest -isrc test/Test.hs && ./test/Test
