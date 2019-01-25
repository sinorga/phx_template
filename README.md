# PhxTemplate

[![CircleCI](https://circleci.com/gh/sinorga/phx_template/tree/master.svg?style=svg)](https://circleci.com/gh/sinorga/phx_template/tree/master)

It's template project for releasing phoenix project as Docker image to DigitalOcean.
Database is using PostgreSQL now.

## Development

### Prerequirements

* Docker
* asdf - language version manager

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Release

To build docker image:

`make image`

To test the image with db at local: (First time db image up may failed, the workaround is try again.)

`make run`

## Deploy

Before the Ansible involved, You can deploy the docker image manually with required environment variables (refer to `docker/provision.local.env`).

## Todo

- [X] Build release Docker image.
- [X] Production DB init and migration
- [ ] Ansible for handling secret, ie. cookie, ...
- [ ] CircleCI for running test
- [ ] CircleCI for build image
- [ ] CircleCI for deploy
