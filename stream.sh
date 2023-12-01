#!/usr/bin/env bash

# 11:58:40.022266 IP 203.0.113.9.50801 > 192.0.2.6.80: tcp 0

dev="enp0s1"
ip_addr="192.0.2.6"
proto="tcp"
excluded_ports=()

for excluded in "${excluded_ports[@]}"; do
	excluded_args+=" and not port $excluded"
done

ip_len="${#ip_addr}"

# shellcheck disable=SC2086
tcpdump -n -q -l -i "$dev" "$proto" and dst net "$ip_addr" $excluded_args 2>/dev/null | while IFS= read -r line; do
	daddr_and_dport="$(awk '{ print $5 }' <<< "$line")"
	dport="${daddr_and_dport:ip_len+1:-1}"
	echo "$dport"
done
