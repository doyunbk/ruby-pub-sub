#!/bin/sh
bundle install --jobs 20 --retry 5

set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /project/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle exec rails s -b 0.0.0.0