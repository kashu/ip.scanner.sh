#!/bin/bash
#Author: kashu
#Date: 2013-12-05
#Filename: ip_scan.sh
#Description: ip scan (ICMP protocol)

NIC=eth1
tmp_list=/tmp/ip_scan.list
ip_list=./ip_scan.list
>$tmp_list
>$ip_list
ip_addr="`ip -4 -o ad s $NIC|awk '{print $4}'|cut -d'.' -f1-3`."
for i in {1..254}; do
  {
    ping -I $NIC -i0.2 -c2 -s1 -W2 "${ip_addr}""${i}" &> /dev/null && echo "${ip_addr}""${i}" >> $tmp_list
  } &
done
wait
sort -nuk4 -t'.' $tmp_list >> $ip_list
my_ip="`ip -4 -o ad s $NIC|awk '{print $4}'|cut -d'/' -f1`"
sed -i "/${my_ip}/d" $ip_list
cat $ip_list
