
bosh delete-env $BD/bosh.yml \
 --state state.json \
 --vars-store ./creds.yml \
 -o ~/workspace/bosh-deployment/virtualbox/cpi.yml \
 -o ~/workspace/bosh-deployment/virtualbox/outbound-network.yml \
 -o ~/workspace/bosh-deployment/bosh-lite.yml \
 -o ~/workspace/bosh-deployment/jumpbox-user.yml \
 -v director_name=vbox \
 -v internal_ip=172.28.98.50 \
 -v internal_gw=192.168.56.1 \
 -v internal_cidr=192.168.56.0/24 \
 -v network_name=vboxnet0 \
 -v outbound_network_name=NatNetwork
