echo =====================ip network ============================
echo command ip a is running
ip a | grep -n -e eno1 -e eno2
echo press any key!
read var
echo ===================== mother bord serial ===================
echo command dmidecode is running
dmidecode -t 2 |grep Serial
echo press any key to continue !
read var
echo ====================== IPMI version =======================
echo command ipmicfg-linux.x86 is running
ipmicfg-linux.x86 -ver
echo press any key to continue !
read var
echo ====================== IPMI Logs =======================
echo command ipmitool sel elist is running
ipmitool sel elist > IPMI.Log
echo see the result in IPMI.log
echo press any key to continue !
read var
echo ====================== RAM information ===============================
echo command dmidecode is running
dmidecode --type 17 | egrep -i "Manu|Part"
echo press any key to continue !
read var
echo ====================== Power information ===============================
echo command dmidecode is running
dmidecode | egrep -n6 -i "System Power Supply"
echo press any key to continue !
read var
echo ====================== date ===============================
echo command date is running
date
echo press any key to continue !
read var
echo ======================= up time ===========================
echo command uptime is running
uptime
echo press any key to continue !
read var
echo ======================= last ==============================
echo command last is running
last 
echo press any key to continue !
read var
echo ===================== lvsdisplay ============================
echo command lvdisplay is running
lvdisplay
echo press any key to continue !
read var
echo ===================== pvdisplay ============================
echo command pvdisplay is running
pvdisplay
echo press any key to continue !
read var
#echo ===================== Error count ============================
#MegaCli64 pdinfo a0
#echo press any key to continue !
#read var
echo =====================write back and write through ============================
echo command MegaCli64 ldinfo is running
MegaCli64 ldinfo lall aall |grep  -n6 -e Name -e Virtual -e RAID -e State -e BBU
echo press any key to continue !
read var
echo ===================== Cash valet version ============================
echo command MegaCli64 adpbbucmd is running
MegaCli64 adpbbucmd a0 | grep Module 
echo press any key to continue !
read var
echo ===================== Auto Rebuild ============================
echo command MegaCli64 -AdpAutoRbld is running
MegaCli64 -AdpAutoRbld -Dsply -aAll
echo press any key to continue !
read var
echo ===================== Raid version ============================
echo command MegaCli64 Adpallinfo is running
#MegaCli64 Adpallinfo a0 | egrep Product
MegaCli64 Adpallinfo a0 | egrep 'Product|Serial No|FW Package|FW Version'
echo press any key to continue !
read var
echo ===================== Disk Status ============================
echo command MegaCli64 pdlist aall is running
MegaCli64 pdlist aall #|grep -e Enclosure -e Slot -e PD -e Raw -e Frimware -e Temperature -e Port 
echo press any key to continue !
read var
echo ===================== Pool status ============================
echo command vgs  is running
vgs 
echo press any key to continue !
read var
echo -------------------------- pvs -----------------------------------
echo command pvs is running
pvs
echo press any key to continue !
read var
echo ===================== Lun status ============================
echo command lvs is running
lvs
echo press any key to continue !
read var
echo ===================== ipmi version ============================
echo command ipmicfg-linux.x86 is running
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
echo command  ipmicfg-linux.x86 -fan 1 is running
ipmicfg-linux.x86 -fan 1
echo press any key to continue !
read var
echo ===================== Frimware  ============================
echo command cat /logfiles/version is running
cat /logfiles/version
echo press any key to continue !
read var
echo ===================== Megacli version  ===========================
echo command MegaCli64 -v is running
MegaCli64 -v
echo press any key to continue !
read var
echo ===================== Storcli version  ============================
echo command storcli -v is running
storcli -v
echo press any key to continue !
read var
echo ===================== LVM version  ============================
echo command lvm version is running
lvm version
echo press any key to continue !
read var
echo ===================== Fibre Card version  ============================
echo command modinfo qla2xxx | grep version is running
modinfo qla2xxx | grep version
echo press any key to continue !
read var
echo ===================== Rapidtier version  ============================
echo command rapidtier version is running
rapidtier version
echo press any key to continue !
read var
echo ===================== Scstadmin version  ============================
cat /etc/scst.conf | grep SCST
echo press any key to continue !
read var
echo ===================== kernel version  ============================
echo command uname -r is running
uname -r
echo press any key to continue !
read var
echo ===================== scst  ============================
echo command lsmod  is running
lsmod | grep scst
echo press any key to continue !
read var
echo ===================== rapidstore  ============================
echo command lsmod is running
lsmod | grep rapidstor
echo press any key to continue !
read var
echo ===================== hotspare  ============================
echo command MegaCli64 adpgetprop ENABLEEGHSP  a0 is running
MegaCli64 adpgetprop ENABLEEGHSP  a0
echo press any key to continue !
read var
echo ===================== iostat  ============================
echo command iostat is running
timeout 5s iostat -Ntx -y -d 1 > iostat.out
echo see the result in iostat.out
echo press any key to continue !
read var
echo ===================== Get dmesg Log  ============================
echo command dmesg -wT is running
timeout 5s dmesg -wT |egrep "TM fn ABORT_TASK/0" > dmesg.out
echo see the result in dmesg.out
echo press any key to continue !
read var
echo ===================== Get sab-ui Log  ============================
echo command tailf /var/log/sab-ui.log is running
timeout 5s tailf /var/log/sab-ui.log > sab-ui.out
echo see the result in sab-ui.out
echo press any key to continue !
read var
echo ===================== Get sab-syslog Log  ============================
echo command tailf /var/log/sab-syslog.log is running
timeout 5s  tailf /var/log/sab-syslog.log > sab-syslog.out
echo see the result in sab-syslog.out
echo press any key to continue !
read var
echo ===================== Get message Log  ============================
echo command tailf /var/log/messages is running
timeout 5s tailf /var/log/messages > message.out
echo see the result in message.out
echo press any key to continue !
read var
echo ===================== sar  ============================
echo command sar is running
sar -d > sar.out
echo see the result in sar.out
echo press any key to continue !
read var
echo ===================== Disk  ============================
echo command MegaCli64 pdlist a0 is running
MegaCli64 pdlist a0 
#echo press any key to continue !
#read var
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
echo PM IS DONE!
echo edited by amozegar!
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
echo  PM IS DONE!
echo edite by amozegar!
