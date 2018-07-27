#!/usr/bin/env bash

rm -rf Carnap-Server/static/ghcjs/allactions/*.js
for file in `ls Carnap-GHCJS/.stack-work/dist/x86_64-linux/*ghcjs/build/AllActions/AllActions.jsexe/{lib,out,runmain}.js`; do
  base=`basename $file`;
  ln -s --relative $file Carnap-Server/static/ghcjs/allactions; 
done
