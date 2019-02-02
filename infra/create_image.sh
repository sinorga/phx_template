#!bin/sh

BASEDIR=$(dirname "$0")
cd $BASEDIR

packer build \
  -var-file="secret.tfvars" \
  image_template.json

cd -
