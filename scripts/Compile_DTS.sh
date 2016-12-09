#!/bin/bash
set -e
##############
## Cover sys_config.fex to dts

if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi

DTC_COMPILER=${ROOT}/kernel/scripts/dtc/dtc
DTC_SRC_PATH=${ROOT}/kernel/arch/arm64/boot/dts
DTC_DEP_FILE=${DTC_SRC_PATH}/.sun50iw2p1-cheetah-p1.dtb.d.dtc.tmp
DTC_SRC_FILE=${DTC_SRC_PATH}/.sun50iw2p1-cheetah-p1.dtb.dts
DTC_INI_FILE_BASE=${ROOT}/external/sys_config.fex
DTC_INI_FILE=${ROOT}/external/sys_config_fix.fex



function sys_config_2_dts()
{
	#these args used to conver sys_config to dts
	cp $DTC_INI_FILE_BASE $DTC_INI_FILE
	sed -i "s/\(\[dram\)_para\(\]\)/\1\2/g" $DTC_INI_FILE
	sed -i "s/\(\[nand[0-9]\)_para\(\]\)/\1\2/g" $DTC_INI_FILE

	if [ ! -f $DTC_DEP_FILE ]; then
		printf "Script_to_dts: Can not find [%s-%s.dts]. Will use common dts file instead.\n" ${PACK_CHIP} ${PACK_BOARD}
		DTC_DEP_FILE=${DTC_SRC_PATH}/.${PACK_CHIP}-soc.dtb.d.dtc.tmp
		DTC_SRC_FILE=${DTC_SRC_PATH}/.${PACK_CHIP}-soc.dtb.dts
	fi

	$DTC_COMPILER -O dtb -o ${ROOT}/output/sunxi.dtb	\
		-b 0			\
		-i $DTC_SRC_PATH	\
		-F $DTC_INI_FILE	\
		-d $DTC_DEP_FILE $DTC_SRC_FILE

	printf "Conver script to dts ok.\n"
	return
}

sys_config_2_dts
