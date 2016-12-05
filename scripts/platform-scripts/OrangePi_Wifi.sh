#!/bin/sh

set -e

insmod /lib/modules/3.10.102/kernel/net/wireless/cfg80211.ko
insmod /lib/modules/3.10.102/kernel/drivers/net/wireless/bcmdhd/bcmdhd.ko
insmod /lib/modules/3.10.102/kernel/drivers/bluetooth/bcm_btlpm.ko
