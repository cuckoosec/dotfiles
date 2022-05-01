#!/bin/bash

iptables -A INPUT -i eth0 --protocol tcp --destination-port 22 -s 192.168.42.0/24 --match state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 --protocol tcp --destination-port 22 -s 10.4.20.0/24 --match state --state NEW,ESTABLISHED -j ACCEPT -j ACCEPT
iptables -A INPUT -i eth0 --protocol udp --sport 53 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 8787 -m state --state NEW,ESTABLISHED -j ACCEPT 

# Outbond
iptables -A OUTPUT -i eth0 -p tcp --sport 22 -j ACCEPT
iptables -A OUTPUT -i eth0 -p tcp --sport 23 -j ACCEPT
iptables -A OUTPUT -i eth0 -p tcp --sport 43 -j ACCEPT
iptables -A OUTPUT -i eth0 -p udp --sport 53 -j ACCEPT # Set for DNS server
iptables -A OUTPUT -i eth0 -p tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -i eth0 -p udp --sport 123 -j ACCEPT
iptables -A OUTPUT -i eth0 -p tcp --sport 443 -j ACCEPT
iptables -A OUTPUT -i eth0 -p tcp --sport 8787 -m state --state ESTABLISHED -j ACCEPT # rstudio


iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables --policy INPUT DROP
iptables --policy OUTPUT DROP
iptables --policy FORWARD DROP