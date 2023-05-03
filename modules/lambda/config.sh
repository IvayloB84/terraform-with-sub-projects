#!/bin/bash
mkdir -p ./lambda/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip'} ./ ./lambda/ && cd ./lambda/ && npm install --legacy-peer-deps && cd -
