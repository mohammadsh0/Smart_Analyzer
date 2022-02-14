echo =====================ip network ============================
ip a | grep -n -e eno1 -e eno2
echo press any key!
read var
echo ===================== mother bord serial ===================
dmidecode -t 2 |grep Serial
echo press any key to continue !
read var
echo ====================== date ===============================
date
echo press any key to continue !
read var
echo ======================= up time ===========================
uptime
echo press any key to continue !
read var
echo ======================= last ==============================
last 
echo press any key to continue !
read var
echo ===================== lvsdisplay ============================
lvdisplay
echo press any key to continue !
read var
echo ===================== pvdisplay ============================
pvdisplay
echo press any key to continue !
read var
echo =====================write back and write through ============================
MegaCli64 ldinfo lall aall |grep  -n6 -e Name -e Virtual -e RAID -e State -e BBU
echo press any key to continue !
read var
echo ===================== Frimware version ============================
MegaCli64 adpbbucmd a0 | grep Module 
echo press any key to continue !
read var
echo ===================== Raid version ============================
MegaCli64 Adpallinfo a0 | egrep Product
echo press any key to continue !
read var
echo =====================Raid Versions ============================
MegaCli64 Adpallinfo a0 | egrep 'Product|Serial No|FW Package|FW Version'
echo press any key to continue !
read var
echo ===================== Disk Status ============================
MegaCli64 pdlist aall |grep -e Enclosure -e Slot -e PD -e Raw -e Frimware -e Temperature -e Port 
echo press any key to continue !
read var
echo ===================== Pool status ============================
vgs 
echo press any key to continue !
read var
echo -------------------------- pvs -----------------------------------
pvs
echo press any key to continue !
read var
echo ===================== Lun status ============================
lvs
echo press any key to continue !
read var
echo ===================== ipmi version ============================
ipmicfg-linux.x86 -ver
echo press any key to continue !
read var
echo ===================== ipmi ip ============================
#c= ipmicfg-linux.x86 -m
a=$(ipmicfg-linux.x86 -m |grep IP)
echo the ipmi is $a do you want to change to defult? [yes or  no]
read var
if [ $var == "yes" ]
then
ipmitool lan set 1 ipaddr 192.168.68.3
ipmitool lan set 1 netmask 255.255.255.0
ipmitool lan set 1 defgw ipaddr 192.168.68.1
q=$(ipmicfg-linux.x86 -m |grep IP)
echo the ipmi ip is $q
fi
echo press any key to continue !
read var
echo ===================== Fan speed  ============================
ipmicfg-linux.x86 -fan 1
echo press any key to continue !
read var
echo ===================== Frimware  ============================
cat /logfiles/version
echo press any key to continue !
read var
echo ===================== Megacli version  ===========================
MegaCli64 -v
echo press any key to continue !
read var
echo ===================== Storcli version  ============================
storcli -v
echo press any key to continue !
read var
echo ===================== Scstadmin version  ============================
cat /etc/scst.conf | grep SCST
echo press any key to continue !
read var
echo ===================== kernel version  ============================
uname -r
echo press any key to continue !
read var
echo ===================== scst  ============================
lsmod | grep scst
echo press any key to continue !
read var
echo ===================== rapidstore  ============================
lsmod | grep rapidstor
echo press any key to continue !
read var
echo ===================== hotspare  ============================
MegaCli64 adpgetprop ENABLEEGHSP  a0
echo press any key to continue !
read var
echo ===================== iostat  ============================
timeout 5s iostat -Ntx -y -d 1 > iostat.out
echo see the result in iostat.out
echo press any key to continue !
read var
echo ===================== sar  ============================
sar -d > sar.out
echo see the result in sar.out
echo press any key to continue !
read var
echo ===================== Disk  ============================
MegaCli64 pdlist a0 | grep -i inquiry
echo press any key to continue !
read var
echo ======================smart disk parameter ========================
smartctl --scan |grep /dev/bus > disk.txt
sed  's/^/smartctl -a /'  disk.txt > smartdisk.sh
sh smartdisk.sh >smartparameter.out
rm smartdisk.sh
echo press any key to continue !
read var
echo ===================== copy back status  ============================
p=$( MegaCli64 -AdpGetProp -CopyBackDsbl -a0 -Nolog |grep  -oh "Disable"* )
q=$( MegaCli64 -AdpGetProp -CopyBackDsbl -a0 -Nolog |grep  -oh "Enable"* )
MegaCli64 -AdpGetProp -CopyBackDsbl -a0 -Nolog
#echo $p
#read var
if [ $p == "Disable" ]
then 
echo it is ok
exit 0
fi
 
if [ $q == "Enable" ]
then
echo copyback is enable do you wnat to disable?
read var
if [ $var == "yes" ]
then
MegaCli64 -AdpSetProp -CopyBackDsbl 1 -a0 -Nolog
fi
fi
MegaCli64 -AdpGetProp -CopyBackDsbl -a0 -Nolog |grep CopyBack
echo  done!
echo  PM IS DONE!
echo ===================== FC Port name & Speed & Connected  ============================
cat /sys/class/fc_host/host*/port_name
cat /sys/class/fc_host/host*/speed
cat /sys/class/fc_host/host*/port_state
cat /sys/class/fc_host/host*/supported_speeds
cat /sys/class/fc_host/host*/symbolic_name
echo ===================== Motherboard Version ============================
dmesg | grep -i dmi: | cut -d ":" -f 2
echo  PM IS DONE!
echo edite by Team1!
