#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Install necessary packages
sudo apt install -y git unbound

# Allow necessary firewall rules
sudo ufw allow 80/tcp
sudo ufw allow 53/tcp
sudo ufw allow 53/udp
sudo ufw allow 67/tcp
sudo ufw allow 67/udp
sudo ufw allow 546:547/udp

# Add user pihole and add to sudo group
sudo adduser --gecos "" pihole
sudo usermod -aG sudo pihole

# Download root hints file for Unbound
sudo wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints

# Define the configuration
read -r -d '' CONFIG << EOM
# Unbound configuration goes here
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: yes

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
   # private-address: 169.254.0.0/16
   # private-address: 172.16.0.0/12
   # private-address: 10.0.0.0/8
    private-address: 192.168.0.0/24
    private-address: fd00::/8
    private-address: fe80::/10
EOM

# Check if the directory exists and if not, create it
sudo mkdir -p /etc/unbound/unbound.conf.d/

# Write the configuration to the file
echo "$CONFIG" | sudo tee /etc/unbound/unbound.conf.d/pi-hole.conf

# Update the system again
sudo apt-get update

# Clone Pi-hole repository and run the installation script
sudo -u pihole git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
cd "Pi-hole/automated install/"
sudo -u pihole bash basic-install.sh

# Update Pi-hole
sudo -u pihole pihole -up

# Restart Unbound service
sudo service unbound restart

# Test Unbound setup
dig pi-hole.net @127.0.0.1 -p 5335
dig fail01.dnssec.works @127.0.0.1 -p 5335
dig dnssec.works @127.0.0.1 -p 5335
