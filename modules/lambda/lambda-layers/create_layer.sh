#!/bin/bash
mkdir -p ./source/nodejs/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip','source/'} ./ ./source/nodejs/ && cd ./source/nodejs/ && npm install --legacy-peer-deps && cd -