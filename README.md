# PhxTemplate

[![CircleCI](https://circleci.com/gh/sinorga/phx_template/tree/master.svg?style=svg)](https://circleci.com/gh/sinorga/phx_template/tree/master)

It's template project for releasing phoenix project as Docker image to DigitalOcean.
Database is using PostgreSQL now.

## Development

Before start development your project, Please replace all `phx_template` in this Repo to your own project name.

To start your Phoenix server:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Install Node.js dependencies with `cd assets && npm install`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## CircleCI

Status Badges:
  Go to project setting page of CircleCI, its under NOTIFICATIONS section.

Environment variables:

* DOCKER_USER: for image build
* DOCKER_PASS: for image push

## Release

 1. OTP release with [Distillery](https://github.com/bitwalker/distillery)
    1. Runtime configuration by config providers.
    2. Auto database create by pre hook.
    3. Database migration command supported in production.
 2. Release as Docker image.
 3. Unit testing by CircleCI.
 4. Build Docker image by CircleCI.

### Prerequirements

* Docker
* asdf - language version manager

For Setup infra and deploy

* terraform
* packer
* ansible

### Usage

To build docker image:

`make image DOCKER_USER=[YOUR_DOCKER_USER_NAME]`

To test the image with db at local: (First time db image up may failed, the workaround is try again.)

`make run`

### Infra

If you want to handle deployment by yourself, You can deploy the docker image manually with required environment variables (refer to `deploy/provision.local.env`).

Setup Image:

Using `packer` to create image snapshot as base image. At first, you need to setup DigitalOcean secrets.

`cp infra/secret.vars.example.json infra/secret.vars.json`

Edit the `infra/secret.vars.json` file with your won setting. The `do_token` is your Personal access token of DigitalOcean and `ssh_fingerprint` is the fingerprint of SSH key which you added to DigitalOcean. (Here assume you add the ssh key at "~/.ssh/id_rsa.pub" to DigitalOcean.)

* [How to create access token](https://www.digitalocean.com/docs/api/create-personal-access-token/)
* [How to Add SSH Keys to Droplets](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1604)

After setup the secret file, you can build the image by

`. ./infra/create_image.sh`

If it is created successfully, you can get the snapshot name from terminal output like below.

```log
...
==> Builds finished. The artifacts of successful builds are:
--> phx_template_base: A snapshot was created: 'packer-1548918676' (ID: 43089013) in regions 'sgp1'
```

Launch server node:

Replace snapshot image name to the variable `base_image_name` in `infra/single_node.sh` file. Then launch a new VM by

`. ./infra/single_node.sh apply`

If it is launched successfully, you can the public IP of node from termil output like below.

```log
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

Public ip = 123.123.123.123
```

### Deploy docker image of your service

Place the node ip in `deploy/ansible/production/hosts`.
Example:

```hosts
[all_in_one]
123.123.123.123
```

Place the username of docker hub in the field `docker_user` in `deploy/ansible/group_vars/all/vars.yml`. To handle the production secret values, please use [Ansible Vault](https://docs.ansible.com/ansible/2.4/vault.html) to encrypt it. There are two fields need to be encrypted at beginning, `web.secret_key_base`, `web.erlang.cookie` and `db.password`.

1. Rename the `deploy/ansible/.example.vault_pass` to `deploy/ansible/.vault_pass`. Then put your Vault password in it.
2. Get encrypted the value by `ansible-vault`, It's the example of `secret_key_base`, `ansible-vault encrypt_string --vault-password-file deploy/ansible/.vault_pass "YOUR_SECRET_BASE" --name 'secret_key_base'`
3. Place the encrypted value in `deploy/ansible/production/group_vars/all/secret.yml`.

First time, you need to setup the remote server by

`. ./deploy/setup.sh production`

Then deploy the docker image to remote server by

`. ./deploy/deploy.sh production`

**NOTE:** Here assume you have built and pushed the latest docker image to docker hub by CircleCI already, or you need to do it manually.

If the deploy successfully, you can see the phoenix page by visit the http://[NODE_PUBLIC_IP].

## Todo

- [X] Build release Docker image.
- [X] Production DB init and migration
- [X] CircleCI for running test
- [X] CircleCI for build image
- [X] Manually infra setup and deploy.
- [ ] CircleCI for deploy
- [ ] Database node setup
- [ ] Project generator based on Mix task.
