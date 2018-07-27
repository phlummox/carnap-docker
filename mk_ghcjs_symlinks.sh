#!/usr/bin/env bash
printf 'regenerating symlinks ...\n'
set -x
mkdir -p Carnap-Server/static/ghcjs/allactions/
rm -rf Carnap-Server/static/ghcjs/allactions/*.js
printf 'removed symlinks\n'
for file in `ls Carnap-GHCJS/.stack-work/dist/x86_64-linux/*Cabal-1.24*ghcjs/build/AllActions/AllActions.jsexe/{lib,out,runmain}.js`; do

  ln -s --relative $file Carnap-Server/static/ghcjs/allactions; 
done
printf 'done\n'

