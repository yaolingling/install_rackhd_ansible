# !/bin/bash

# replace with your own github account
github_account=$1

mkdir -p ~/src

for repo in $(echo "on-core on-tasks on-taskgraph on-http on-dhcp-proxy on-tftp on-syslog");do
  # clone my forked repo and set origin to my forked repo
  pushd ~/src
  git clone https://github.com/${github_account}/$repo.git

  # set upstream to RackHD official repo
  popd && pushd ~/src/$repo
  git remote add upstream https://github.com/RackHD/$repo.git

  # sync up the latest change of upstream into origin
  git fetch upstream && git rebase upstream/master

  popd
done

#solve the problem that on-http cannot start
/bin/bash ~/src/on-http/install-swagger-ui.sh
