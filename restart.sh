#!/usr/bin/env bash

kill `cat /tmp/ccmonitor.pid`
cd /home/eggbuild/ccmonitor/current
bundle exec unicorn -c "/home/eggbuild/ccmonitor/current/config/unicorn.rb" -E production -D
