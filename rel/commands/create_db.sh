#!/bin/sh
release_ctl eval --mfa "PhxTemplate.ReleaseTasks.create_db/1" --argv -- "$@"
