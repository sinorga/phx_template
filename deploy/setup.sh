#!/bin/sh

INVENTORY=${1:-local}
BASE_DIR=$(dirname "$0")
ANSIBLE_DIR=$BASE_DIR/ansible

ansible-playbook --vault-password-file $ANSIBLE_DIR/.vault_pass -i $ANSIBLE_DIR/$INVENTORY $ANSIBLE_DIR/site_setup.yml
