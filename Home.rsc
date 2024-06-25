# model = RouterBOARD 962UiGS-5HacT2HnT
# serial number = 1234567890AB
# software id = RouterOS 6.49.10 1234-ABCD

/interface bridge
add admin-mac=7A:11:F2:9E:25:C7 auto-mac=no name=bridge1

/interface wireless
set [ find default-name=wlan1 ] band=2ghz-onlyg disabled=no mode=ap-bridge ssid=XSask-2
set [ find default-name=wlan2 ] band=5ghz-onlyac disabled=no mode=ap-bridge ssid=XSask

/interface vlan
add interface=ether1 name=vlan1 vlan-id=3000

/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk group-key-update=1d mode=dynamic-keys supplicant-identity=MikroTik wpa2-pre-shared-key=password

/ip pool
add name=pool1 ranges=192.168.17.129-192.168.17.190

/ip dhcp-server
add address-pool=pool1 disabled=no interface=bridge1 lease-time=1d name=server1

/interface bridge port
add bridge=bridge1 interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether5
add bridge=bridge1 interface=wlan1
add bridge=bridge1 interface=wlan2

/ip address
add address=192.168.17.1/24 interface=bridge1 network=192.168.17.0
add address=192.0.2.28/24 interface=vlan1 network=192.0.2.0
add address=192.0.2.29/24 interface=vlan1 network=192.0.2.0

/ip dhcp-server config
set store-leases-disk=never

/ip dhcp-server network
add address=192.168.17.0/25 dns-server=192.168.17.1 gateway=192.168.17.1
add address=192.168.17.128/25 dns-server=45.90.28.227,45.90.30.227 gateway=192.168.17.1

/ip dns
set allow-remote-requests=yes servers=45.90.28.181,45.90.30.181

/ip firewall filter
add action=accept chain=forward connection-state=established,related
add action=accept chain=input connection-state=established,related
add action=accept chain=input protocol=icmp
add action=accept chain=input in-interface=bridge1
add action=drop chain=input

/ip firewall nat
add action=src-nat chain=srcnat out-interface=vlan1 src-address=192.168.17.0/25 to-addresses=192.0.2.28
add action=src-nat chain=srcnat out-interface=vlan1 src-address=192.168.17.128/25 to-addresses=192.0.2.29

/ip route
add distance=1 gateway=192.0.2.254

/system clock
set time-zone-autodetect=no time-zone-name=America/Regina

/system logging
set 0 topics=info,!wireless
set 3 action=memory

/system ntp server
set enabled=yes

/tool graphing interface
add interface=vlan1

/tool graphing resource
add
