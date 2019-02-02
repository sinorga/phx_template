#!bin/sh

CMD=${1:-apply}
BASEDIR=$(dirname "$0")
cd $BASEDIR

terraform $CMD \
  -target "digitalocean_droplet.single_node" \
  -var-file="secret.vars.json" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "base_image_name=packer-xxxxxxxx"

cd -
