#!/bin/bash

cd ~/src/on-core
npm install

for repo in $(echo "on-tasks on-taskgraph on-http on-dhcp-proxy on-tftp on-syslog");do
  pushd ~/src/$repo
  npm install
  npm link ../on-core
done

for repo in $(echo "on-taskgraph on-http");do
  pushd ~/src/$repo
  npm link ../on-tasks
done
