#!/bin/bash
#export USER_NAME=marbax
for i in crawler-ui crawler-app; do cd $i; docker build . -t marbax/$i:test; cd -; done
