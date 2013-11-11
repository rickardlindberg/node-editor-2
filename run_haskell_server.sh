#!/bin/sh
ghc --make -isrc src/Server.hs -outputdir bin -o bin/Server && ./bin/Server
