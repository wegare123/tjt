#!/bin/bash
#tjt (Wegare)
stop () {
host="$(cat /root/akun/tjt.txt | tr '\n' ' '  | awk '{print $1}')"
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)" 
killall -q badvpn-tun2socks trojan ping-tjt httping
route del 8.8.8.8 gw "$route" metric 0 2>/dev/null
route del 8.8.4.4 gw "$route" metric 0 2>/dev/null
route del "$host" gw "$route" metric 0 2>/dev/null
ip link delete tun1 2>/dev/null
/etc/init.d/dnsmasq restart 2>/dev/null
}
host2="$(cat /root/akun/tjt.txt | tr '\n' ' '  | awk '{print $1}')"
port2="$(cat /root/akun/tjt.txt | tr '\n' ' '  | awk '{print $2}')" 
pass2="$(cat /root/akun/tjt.txt | tr '\n' ' '  | awk '{print $3}')" 
bug2="$(cat /root/akun/tjt.txt | tr '\n' ' '  | awk '{print $4}')" 
udp2="$(cat /root/akun/tjt.txt | tr '\n' ' '  | awk '{print $5}')" 
clear
echo "Inject trojan by wegare"
echo "1. Sett Profile"
echo "2. Start Inject"
echo "3. Stop Inject"
echo "4. Enable auto booting & auto rekonek"
echo "5. Disable auto booting & auto rekonek"
echo "e. exit"
read -p "(default tools: 2) : " tools
[ -z "${tools}" ] && tools="2"
if [ "$tools" = "1" ]; then

echo "Masukkan host/ip" 
read -p "default host/ip: $host2 : " host
[ -z "${host}" ] && host="$host2"

echo "Masukkan port" 
read -p "default port: $port2 : " port
[ -z "${port}" ] && port="$port2"

echo "Masukkan password/key" 
read -p "default password/key: $pass2 : " pass
[ -z "${pass}" ] && pass="$pass2"

echo "Masukkan bug" 
read -p "default bug: $bug2 : " bug
[ -z "${bug}" ] && bug="$bug2"

read -p "ingin menggunakan port udpgw y/n " pilih
if [ "$pilih" = "y" ]; then
echo "Masukkan port udpgw" 
read -p "default udpgw: $udp2 : " udp
[ -z "${udp}" ] && udp="$udp2"
badvpn="badvpn-tun2socks --tundev tun1 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp --udpgw-connection-buffer-size 65535 --udpgw-transparent-dns &"
elif [ "$pilih" = "Y" ]; then
echo "Masukkan port udpgw" 
read -p "default udpgw: $udp2 : " udp
[ -z "${udp}" ] && udp="$udp2"
badvpn="badvpn-tun2socks --tundev tun1 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp --udpgw-connection-buffer-size 65535 --udpgw-transparent-dns &"
else
badvpn='tun2socks -tunAddr "10.0.0.1" -tunGw  "10.0.0.2" -tunMask "255.255.255.0" -tunName "tun1" -tunDns "8.8.8.8,8.8.4.4" -proxyType "socks" -proxyServer "127.0.0.1:1080" &'
fi

if [[ -z $udp ]]; then
udp="-"
fi
echo "$host
$port
$pass
$bug
$udp" > /root/akun/tjt.txt
cat <<EOF> /root/akun/tjt.json
{
    "run_type": "client",
    "local_addr": "127.0.0.1",
    "local_port": 1080,
    "remote_addr": "$host",
    "remote_port": $port,
    "password": [
        "$pass"
    ],
    "log_level": 1,
    "ssl": {
        "verify": false,
        "verify_hostname": true,
        "cert": "",
        "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:AES128-SHA:AES256-SHA:DES-CBC3-SHA",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "sni": "$bug",
        "alpn": [
            "h2",
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "curves": ""
    },
    "tcp": {
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    }
}

EOF
cat <<EOF> /usr/bin/gproxy-tjt
$badvpn
EOF
chmod +x /usr/bin/gproxy-tjt
echo "Sett Profile Sukses"
sleep 2
clear
/usr/bin/tjt
elif [ "${tools}" = "2" ]; then
cek="$(cat /root/akun/tjt.txt)"
if [[ -z $cek ]]; then
echo "anda belum membuat profile"
exit
fi
stop
ipmodem="$(route -n | grep -i 0.0.0.0 | head -n1 | awk '{print $2}')" 
echo "ipmodem=$ipmodem" > /root/akun/ipmodem.txt
udp="$(cat /root/akun/tjt.txt | tr '\n' ' '  | awk '{print $5}')" 
host="$(cat /root/akun/tjt.txt | tr '\n' ' '  | awk '{print $1}')"
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)"

trojan -c /root/akun/tjt.json &
sleep 3
ip tuntap add dev tun1 mode tun
ifconfig tun1 10.0.0.1 netmask 255.255.255.0
/usr/bin/gproxy-tjt
route add 8.8.8.8 gw $route metric 0
route add 8.8.4.4 gw $route metric 0
route add $host gw $route metric 0
route add default gw 10.0.0.2 metric 0
echo '
#!/bin/bash
#tjt (Wegare)
httping m.google.com' > /usr/bin/ping-tjt
chmod +x /usr/bin/ping-tjt
/usr/bin/ping-tjt > /dev/null 2>&1 &
sleep 5
elif [ "${tools}" = "3" ]; then
stop
echo "Stop Suksess"
sleep 2
clear
/usr/bin/tjt
elif [ "${tools}" = "4" ]; then
cat <<EOF>> /etc/crontabs/root

# BEGIN AUTOREKONEKTJT
*/1 * * * *  autorekonek-tjt
# END AUTOREKONEKTJT
EOF
sed -i '/^$/d' /etc/crontabs/root 2>/dev/null
/etc/init.d/cron restart
echo "Enable Suksess"
sleep 2
clear
/usr/bin/tjt
elif [ "${tools}" = "5" ]; then
sed -i "/^# BEGIN AUTOREKONEKTJT/,/^# END AUTOREKONEKTJT/d" /etc/crontabs/root > /dev/null
/etc/init.d/cron restart
echo "Disable Suksess"
sleep 2
clear
/usr/bin/tjt
elif [ "${tools}" = "e" ]; then
clear
exit
else 
echo -e "$tools: invalid selection."
exit
fi