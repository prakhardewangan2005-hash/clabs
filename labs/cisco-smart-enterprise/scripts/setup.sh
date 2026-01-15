#!/usr/bin/env bash
set -euo pipefail

TOPO="labs/cisco-smart-enterprise/topology.clab.yml"

echo "[1/3] Deploying lab..."
containerlab deploy -t "$TOPO"

echo "[2/3] Configuring IPs + routing..."
docker exec -it clab-cisco-smart-enterprise-r1 bash -lc "
ip link set eth1 up; ip addr add 192.168.10.1/24 dev eth1
ip link set eth2 up; ip addr add 192.168.20.1/24 dev eth2
ip link set eth3 up; ip addr add 192.168.30.1/24 dev eth3
ip link set eth4 up; ip addr add 192.168.40.1/24 dev eth4
ip link set eth5 up; ip addr add 192.168.50.1/24 dev eth5
sysctl -w net.ipv4.ip_forward=1 >/dev/null
"

docker exec -it clab-cisco-smart-enterprise-sales sh -lc "ip link set eth1 up; ip addr add 192.168.10.10/24 dev eth1; ip route add default via 192.168.10.1"
docker exec -it clab-cisco-smart-enterprise-ops   sh -lc "ip link set eth1 up; ip addr add 192.168.20.10/24 dev eth1; ip route add default via 192.168.20.1"
docker exec -it clab-cisco-smart-enterprise-it    sh -lc "ip link set eth1 up; ip addr add 192.168.30.10/24 dev eth1; ip route add default via 192.168.30.1"
docker exec -it clab-cisco-smart-enterprise-mgmt  sh -lc "ip link set eth1 up; ip addr add 192.168.40.10/24 dev eth1; ip route add default via 192.168.40.1"
docker exec -it clab-cisco-smart-enterprise-web   sh -lc "ip link set eth1 up; ip addr add 192.168.50.10/24 dev eth1; ip route add default via 192.168.50.1"

echo "[3/3] Applying ACL-style policies..."
docker exec -it clab-cisco-smart-enterprise-r1 bash -lc "
iptables -F
iptables -P FORWARD ACCEPT
# Sales -> IT blocked
iptables -A FORWARD -s 192.168.10.0/24 -d 192.168.30.0/24 -j DROP
# Ops -> Mgmt blocked
iptables -A FORWARD -s 192.168.20.0/24 -d 192.168.40.0/24 -j DROP
# Mgmt outbound blocked (baseline)
iptables -A FORWARD -s 192.168.40.0/24 -j DROP
echo 'Policies applied.'
"

echo "✅ Setup complete."
