# PhxTemplate

It's template project for releasing phoenix project as Docker image to DigitalOcean.

## Development

### Prerequirements

* Docker
* asdf

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Release

To build docker image:

`make release`

To test the image with db at local:

`make run`

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Todo

- [X] Build release Docker image.
- [ ] Production DB init and migration
- [ ] Ansible for handling secret, ie. cookie, ...
- [ ] CircleCI for running test
- [ ] CircleCI for build image
- [ ] CircleCI for deploy
