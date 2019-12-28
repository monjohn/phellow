#! /usr/bin/env bash
. ~/.bashrc
cd ~/phellow 

git pull

mix deps.get --only prod
MIX_ENV=prod mix compile

npm run deploy --prefix ./assets

# mix do ecto.create, ecto.migrate
# MIX_ENV=prod mix ecto.migrate
# cd assets && npm install && npm run deploy & cd ..
mix phx.digest
mix compile
MIX_ENV=prod mix release --overwrite

_build/prod/rel/phellow/bin/phellow stop
_build/prod/rel/phellow/bin/phellow daemon_iex