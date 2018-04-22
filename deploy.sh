#!/bin/bash

export PORT=3000
export MIX_ENV=prod
export GIT_PATH=/home/cryptotracker/src/cryptotracker

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "cryptotracker" ]; then
	echo "Error: must run as user 'cryptotracker'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/cryptotracker ]; then
	echo mv ~/www/cryptotracker ~/old/$NOW
	mv ~/www/cryptotracker ~/old/$NOW
fi

mkdir -p ~/www/cryptotracker
REL_TAR=~/src/cryptotracker/_build/prod/rel/cryptotracker/releases/0.0.1/cryptotracker.tar.gz
(cd ~/www/cryptotracker && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/cryptotracker/src/cryptotracker/start.sh
CRONTAB

#. start.sh
