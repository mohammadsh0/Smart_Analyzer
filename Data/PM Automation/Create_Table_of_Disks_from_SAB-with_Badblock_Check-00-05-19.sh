#Modified by ehsani

#! /bin/bash

# Disk_info_fields_count=8
# Adapter=a0

# MainFolder=$Main_MainFolder

 MainFolder="$(pwd)"
CurrentFolderName=$(echo "${MainFolder##*/}") # returns just the name of the current folder, not the whole path such as pwd
SystemName=$(cat /etc/hostname)

# Disk_Count=$(MegaCli64 pdgetnum a0 | grep Adapter | awk '{print$8}')
# echo "Disk_Count=$Disk_Count"
# Enc_Count=$(storcli /c0/eall show | egrep 'Port 0|Port 4' | wc -l);
# echo "Enc_Count=$Enc_Count"

 Front_Enc=$(MegaCli64 encinfo a0 | egrep 'ID|Slot|Position' | grep -B 2 "Position                      : 1" | grep -B 1 "Number of Slots               : 24" | grep ID | awk '{print$4}')
 Rear_Enc=$(MegaCli64 encinfo a0 | egrep 'ID|Slot|Position' | grep -B 2 "Position                      : 1" | grep -B 1 "Number of Slots               : 12" | grep ID | awk '{print$4}')



#declare -a JBODEncs [$(($Enc_Count-2))] ; 
# if [ $Enc_Count -gt 2 ] ; then 
# echo "one or more JBODs connected to SAB"; 
# Rear_Enc=$(cat 0.PDlist.txt | grep ID | sort -u | awk '{print$4}' | grep -v $SSD_Enc ) ; 
# fi 

#echo -e "Front_Enc=$Front_Enc\tRear_Enc=$Rear_Enc"
# FrontEncDiskCount="$( MegaCli64 encinfo a0 | egrep 'ID|Physical' | grep -A 1 "Device ID                     : $Front_Enc" | egrep 'Number of Physical Drives' | awk '{print$6}')"
# RearEncDiskCount="$( MegaCli64 encinfo a0 | egrep 'ID|Physical' | grep -A 1 "Device ID                     : $Rear_Enc" | egrep 'Number of Physical Drives' | awk '{print$6}')"

# echo -e "Total No. of Disks=$Disk_Count\tFrontEncDiskCount=$FrontEncDiskCount\tRearEncDiskCount=$RearEncDiskCount"


# echo -e "======================================================================================================================================="  >> Disks_Table.txt
cd $MainFolder/
echo -e "SystemName\tEnc Pos\t[EncID:SlotNo]\tMedia & PD Type\tSerial Number\tOverAllStatus\tFirmware version\tDevice Id\tFirmware State\tMedia Error Count\tOther Error Count\tPredictive Failure Count\tSMART Health\tLong SelfTest\tElements Grown Defect List\tNon Medium Error Count\tPower Up Time\tCurrent Temperature\tBadblock_Result_0x00\tBadblock_Result_0x00_Errors\tBadblock_Result_0x55\tBadblock_Result_0x55_Errors\tBadblock_Result_0xaa\tBadblock_Result_0xaa_Errors\tBadblock_Result_0xff\tBadblock_Result_0xff_Errors"  >> Disks_Table.txt

for Disk in $(ls -d */ | cut -d '/' -f1 );
do

#	MegaCli64 PDinfo Physdrv[$EncID:$Slot_No] $Adapter > Disk.tmp
	SMART_File="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep SMART-After-4)"
	PDInfo_File="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep After_PDClear-PDInfo)"
	Badblock_0x00="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep 0x00)"
	Badblock_0x55="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep 0x55)"
	Badblock_0xaa="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep 0xaa)"
	Badblock_0xff="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep 0xff)"
	
	cp $SMART_File SMART.tmp
	cp $PDInfo_File Disk.tmp


#PDInfo Check	
	EncID="$(cat Disk.tmp | grep ID | awk '{print$4}' )"
	Slot_No="$(cat Disk.tmp | grep Slot | awk '{print$3}' )"
		if [ $Slot_No -lt 10 ] ; then Slot_No="0$Slot_No" ; fi
	Device_Id="$(cat Disk.tmp | grep Id | awk '{print$3}' )"
	Media_Error_Count="$(cat Disk.tmp | grep "Media Error Count" | awk '{print$4}' )"
	Other_Error_Count="$(cat Disk.tmp | grep "Other Error Count" | awk '{print$4}')"
	Predictive_Failure_Count="$(cat Disk.tmp | grep "Predictive Failure Count" | awk '{print$4}' )"
	Firmware_State="$(cat Disk.tmp | grep "Firmware state" | awk '{print$3,$4,$5}' )"
	Inquiry_Data="$(cat Disk.tmp | grep "Inquiry" | awk '{print$3,$4,$5,$6}' )"
	Media_Type="$(cat Disk.tmp | grep "Media Type" | awk '{print$3,$4,$5}' )"
	Media_Type_Clean=""
	if [ "$Media_Type" == "Hard Disk Device" ] ; then Media_Type_Clean="HDD" ; else Media_Type_Clean="SSD" ; fi
	PD_Type="$(cat Disk.tmp | grep "PD Type" | awk '{print$3}' )"
#	PD_Type_Clean=""
	
#	if [ "$PD_Type" == "SAS" ] ; then PD_Type_Clean="SAS" ; else PD_Type_Clean="SATA" ; fi
	
	Enc_Pos=''
		if [ $EncID -eq $Front_Enc ] ; then Enc_Pos='Front' ; elif [ $EncID -eq $Rear_Enc ] ; then Enc_Pos='Rear' ; else Enc_Pos='Unknown' ; fi
	rm -f Disk.tmp
	
#	if [ "$(echo Firmware_State | grep down)" ] ; 
#	then
#		MegaCli64 PDPrpRmv Physdrv[$EncID:$Slot_No] $Adapter
#		MegaCli64 PDPrpRmv Undo Physdrv[$EncID:$Slot_No] $Adapter
#	fi
# SMART Check	
	#smartctl -a -d megaraid,$Device_Id /dev/bus/0  > SMART.tmp
	Serial_Number="$(cat SMART.tmp | grep -i "Serial Number" | awk '{print$3}' )"
	Serial_Number_CLEAN=$Serial_Number  #"$(echo ${Serial_Number:0:8} )"
	SMART_Health="$(cat SMART.tmp | grep "SMART Health Status" | awk '{print$4}' )"
	Elements_GDL="$(cat SMART.tmp | grep "Elements in grown defect list" | awk '{print$6}' )"
	Non_MEC="$(cat SMART.tmp | grep "Non-medium error count" | awk '{print$4}' )"
	Temperature="$(cat SMART.tmp | grep "Current Drive Temperature" | awk '{print$4}' )"
	PowerUp="$(cat SMART.tmp | grep "number of hours powered up" | awk '{print$7}' )"
	Long_ST="$(cat SMART.tmp | grep "Background long" | grep "# 1" | awk '{print$5}' )"
	Firmware_Version="$(cat SMART.tmp | grep "Firmware Version"  | awk '{print$3}' )"
	rm -f SMART.tmp
#Badblock Check	
	
	
	Badblock_Result_0x00="$(cat $Badblock_0x00 | grep Pass | awk '{print$1,$2}')"
	Badblock_Result_0x55="$(cat $Badblock_0x55 | grep Pass | awk '{print$1,$2}')"
	Badblock_Result_0xaa="$(cat $Badblock_0xaa | grep Pass | awk '{print$1,$2}')"
	Badblock_Result_0xff="$(cat $Badblock_0xff | grep Pass | awk '{print$1,$2}')"
	
	
	Badblock_Result_0x00_Errors="$(cat $Badblock_0x00 | grep Pass | cut -d '(' -f2 | awk '{print$1}')"
	Badblock_Result_0x55_Errors="$(cat $Badblock_0x55 | grep Pass | cut -d '(' -f2 | awk '{print$1}')"
	Badblock_Result_0xaa_Errors="$(cat $Badblock_0xaa | grep Pass | cut -d '(' -f2 | awk '{print$1}')"
	Badblock_Result_0xff_Errors="$(cat $Badblock_0xff | grep Pass | cut -d '(' -f2 | awk '{print$1}')"

#############


###########
# PDClear Check


#Overall Check
	OverAllStatus='Passed'
	if [[ (  $Predictive_Failure_Count -ne 0 ) || ( $Media_Error_Count -ne 0 ) || ( $Other_Error_Count -ne 0 )  || ( $Elements_GDL -ne 0 ) || ( $Temperature -gt 55 ) || ( "$SMART_Health" != "OK" ) || ("$Long_ST" != "Completed" ) || ( $Badblock_Result_0x55 != "Pass completed," ) || ( $Badblock_Result_0xaa != "Pass completed," ) || ( $Badblock_Result_0xff != "Pass completed," ) || ( $Badblock_Result_0x00 != "Pass completed," ) || ( $Badblock_Result_0x55_Errors != "0/0/0" ) || ( $Badblock_Result_0xaa_Errors != "0/0/0" ) || ( $Badblock_Result_0xff_Errors != "0/0/0" ) || ( $Badblock_Result_0x00_Errors != "0/0/0" )  ]]
	then
		OverAllStatus='Attention'
	fi	
	
	echo -e "$SystemName\t$Enc_Pos\t[$EncID:$Slot_No]\t$Media_Type_Clean-$PD_Type\t$Serial_Number\t$OverAllStatus\t$Firmware_Version\t$Device_Id\t$Firmware_State\t$Media_Error_Count\t$Other_Error_Count\t$Predictive_Failure_Count\t$SMART_Health\t$Long_ST\t$Elements_GDL\t$Non_MEC\t$PowerUp\t$Temperature\t$Badblock_Result_0x00\t$Badblock_Result_0x00_Errors\t$Badblock_Result_0x55\t$Badblock_Result_0x55_Errors\t$Badblock_Result_0xaa\t$Badblock_Result_0xaa_Errors\t$Badblock_Result_0xff\t$Badblock_Result_0xff_Errors"  >> Disks_Table.txt
		
done

cd $MainFolder/
for i in $( ls -d */ | cut -f1 -d '/' ) ; do ls $i/badblock-0x* | zip  -@ $i/$i-badblock-All.zip ; done

#for i in $( ls -d */ | cut -f1 -d '/' ) ; do rm -f $i/badblockoutput-0x* ; done
