#!/bin/bash

export PORT=3000

cd ~/www/cryptotracker
./bin/cryptotracker stop || true
./bin/cryptotracker start

