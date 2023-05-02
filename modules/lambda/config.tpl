user_data = <<-EOT
mkdir -p ./lambda/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip'} ./ ./lambda/ && cd ./lambda/ && npm install --legacy-peer-deps &&  zip -r payload.zip * && mv payload.zip ../ && cd -
EOT