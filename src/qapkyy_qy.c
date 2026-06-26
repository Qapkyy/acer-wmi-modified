// ON PROGRESS
//
//
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <acpi/video.h>
#include <linux/acpi.h>
#include <linux/backlight.h>
#include <linux/bitfield.h>
#include <linux/bitmap.h>
#include <linux/debugfs.h>
#include <linux/delay.h>
#include <linux/dmi.h>
#include <linux/fixp-arith.h>
#include <linux/fs.h>
#include <linux/hwmon.h>
#include <linux/i8042.h>
#include <linux/init.h>
#include <linux/input.h>
#include <linux/input/sparse-keymap.h>
#include <linux/kernel.h>
#include <linux/leds.h>
#include <linux/minmax.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/platform_profile.h>
#include <linux/rfkill.h>
#include <linux/slab.h>
#include <linux/types.h>
#include <linux/unaligned.h>
#include <linux/units.h>
#include <linux/workqueue.h>

MODULE_AUTHOR("Carlos Corbacho, modified by Qapky")
MODULE_DESCRIPTION("The driver acer-wmi is compatible with Acer Nitro V16 ANV16-71");
MODULE_LICENSE("GPL");

// WMID Interface
#define ACER_WMID_GET_WIRELESS_METHODID 1
#define ACER_WMID_GET_BLUETOOTH_METHODID 2
#define ACER_WMID_SET_WIRELESS_METHODID // UNKNOWN
#define ACER_WMID_SET_BLUETOOTH_METHODID // UNKNOWN

// WMID for Battery Health
#define ACER_WMID_GET_BATTERY_HEALTH_CONTROL_STATUS_METHODID 20
#define ACER_WMID_SET_BATTERY_HEALTH_CONTROL_METHODID 21

/*
  Acer ACPI Method GUIDs
*/
#define WMID_GUID1 "61EF69EA-865C-4BC3-A502-A0DEBA0CB531"
#define WMID_GUID2 "7A4DDFE7-5B5D-40B4-8595-4408E0CC7F56"
#define WMID_GUID3 "79772EC5-04B1-4BFD-843C-61E7F77B6CC9"

/*
 * Acer ACPI event GUIDs
 */
#define ACERWMID_EVENT_GUID  "61EF69EA-865C-4BC3-A502-A0DEBA0CB531"

MODULE_ALIAS("wmi:61EF69EA-865C-4BC3-A502-A0DEBA0CB531")

static int __init acer_wmi_init(void)
{

}

static void __exit acer_wmi_exit(void)
{

}

module_init(acer_wmi_init);
module_exit(acer_wmi_exit);

