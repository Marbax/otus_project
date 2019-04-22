#!/bin/bash
#export USER_NAME=marbax
for i in ui crawler; do cd $i; docker build . -t marbax/$i:test; cd -; done
