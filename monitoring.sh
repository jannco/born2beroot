#!/bin/bash
#Architecture

arch=$(uname -srvmo)

#CPU physical
fcpu=$(cat /proc/cpuinfo | grep "cpu cores" | uniq | awk '{print $4}')

#vCPU
vcpu=$(nproc --all)

#Memory Usage
memusar=$(free --mega | awk '$1 == "Mem:" {printf "%d/%dMB (%.2f%%)\n", $3, $2, $3/$2*100}')

#Disk Usage
disk_proc=$(df --total | awk '"total" == $1 {printf"(%d%%)\n", $3/$2*100}')
diskused="$(df -h --total | awk '\"total\" == $1 {printf\"%.1f/%s \", $3, $2}') $disk_proc"
#diskused=$(df -h --total | awk "\"total\" == \$1 {printf\"%.1f/%s %s\", \$3, \$2, $disk_proc}")

#CPU load
cpu=$(vmstat: 1 1 | tail -1 | awk '{printf"%.1f%%\n", 100-$15}')

#Last boot
lboot=$(who -b | awk '{print $3 " " $4}')

#LVM use
lvm=$(lsblk | grep -q 'lvm' && echo yes || echo no)

#Connections TCP
tcp=$(ss -s | awk '"TCP:" == $1 {printf("%d STABLISHED\n", $4)}')

#User log
log=$(who | awk '{print $1}' | sort -u | wc -l)

#Network
ip=$(hostname -I)
mac=$(ip a show enp0s3 | awk '"link/ether" == $1 {print $2}')

#Sudo 
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "  #Architecture: $arch
        #CPU physica: $fcpu
        #vCPU: $vcpu
        #Memory Usage: $memusar
        #Disk Usage: $diskused
        #CPU load: $cpu
        #Last boot: $lboot
        #LVM use: $lvm
        #Connections TCP: $tcp
        #User log: $log
        #Network: IP $ip ($mac)
        #Sudo: $sudo cmd"
