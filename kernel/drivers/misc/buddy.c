#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>

#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/of_irq.h>
#include <linux/of_gpio.h>
#include <linux/sys_config.h>

#include <linux/regulator/consumer.h>

#define DEV_NAME "orangepi_module"

#ifdef pppppppp
#endif


/*
 * Open USB1 
 */
void H5_DTS_TEST(void)
{
	struct device_node *node;
	unsigned int gpio;

	node = of_find_node_by_type(NULL, "gmac0");
	if (!node) {
		printk("Can't get device node\n");
		goto out;
	}

	gpio = of_get_named_gpio(node, "phy_power_on", 0);
	if (gpio_is_valid(gpio)) {
		printk("GPIO %d valid\n", gpio);
	} else {
		printk("Request GPIO %d\n", gpio);
	}
	printk("Current voltage is %d\n", __gpio_get_value(gpio));

out:
	;
}

/*
 * Open LED 
 */
void open_LED0(void)
{
	struct device_node *node;
	unsigned int gpio;

	node = of_find_node_by_type(NULL, "card_boot");
	if (!node) {
		printk("Can't get device node\n");
		goto out;
	}

	gpio = of_get_named_gpio(node, "sprite_gpio0", 0);
	if (gpio_is_valid(gpio)) {
		printk("GPIO %d valid\n", gpio);
		gpio_request(gpio, NULL);
		gpio_direction_output(gpio, 1);
		__gpio_set_value(gpio, 1);
	} else {
		printk("Request GPIO %d\n", gpio);
		__gpio_set_value(gpio, 1);
	}
	printk("Current voltage is %d\n", __gpio_get_value(gpio));

out:
	;
}

/*
 * Get specify pmu voltage.
 */
int _pmu_voltage(const char *name)
{
	struct regulator *regu = NULL;
	int ret;
	int voltage;

	regu = regulator_get(NULL, name);
	if (IS_ERR(regu)) {
		printk("Failt to get regulator %s\n", name);
		return;
	}
	voltage = regulator_get_voltage(regu);

	/* Enable regulator */
	ret = regulator_enable(regu);
	if (0 != ret) {
		printk("Can't enable regulator\n");
		goto release_regulator;
	}

	/* Disable regulator */
	ret = regulator_disable(regu);
	if (0 != ret) {
		printk("Can't disable regulator\n");
		goto release_regulator;
	}

release_regulator:
	regulator_put(regu);

	return voltage;
}
/*
 * Get all pmu voltage.
 */
void pmu_voltage(void)
{
	printk("=====Current Pmu Voltage=====\n");
	printk("dcdc1 %d\n", _pmu_voltage("vcc-nand"));
	printk("dcdc2 %d\n", _pmu_voltage("vdd-cpua"));
	printk("dcdc3 %d\n", _pmu_voltage("vcc-dcdc3"));
	printk("dcdc4 %d\n", _pmu_voltage("vcc-dcdc4"));
	printk("dcdc5 %d\n", _pmu_voltage("vcc-dram"));
	printk("dcdc6 %d\n", _pmu_voltage("vdd-sys"));
	printk("dcdc7 %d\n", _pmu_voltage("vcc-dcdc7"));
	printk("rtc   %d\n", _pmu_voltage("vcc-rtc"));
	printk("aldo1 %d\n", _pmu_voltage("vcc-pe"));
	printk("aldo2 %d\n", _pmu_voltage("vcc-pl"));
	printk("aldo3 %d\n", _pmu_voltage("vcc-pll"));
	printk("dldo1 %d\n", _pmu_voltage("vcc-hdmi-33"));
	printk("dldo2 %d\n", _pmu_voltage("vcc-mipi"));
	printk("dldo3 %d\n", _pmu_voltage("avdd-csi"));
	printk("dldo4 %d\n", _pmu_voltage("vcc-wifi-io"));
	printk("eldo1 %d\n", _pmu_voltage("vcc-pc"));
	printk("eldo2 %d\n", _pmu_voltage("vcc-lcd-0"));
	printk("fldo1 %d\n", _pmu_voltage("vcc-fldo1"));
	printk("fldo2 %d\n", _pmu_voltage("vdd-cpus"));
	printk("gpio0 %d\n", _pmu_voltage("vcc-ctp"));
	printk("gpio1 %d\n", _pmu_voltage("vcc-gpio1"));
	printk("dc1sw %d\n", _pmu_voltage("vcc-lvds"));
}
/*
 * Set regulator voltage.
 */
void set_regulator_voltage(const char *volname, int target_vol, int max_vol)
{
	struct regulator *regu = NULL;
	int ret = 0;

	/* Change DLD2 */
	regu = regulator_get(NULL, volname);
	if (IS_ERR(regu)) {
		printk("Error: %s some error happen, fail to get regulator\n", volname);
		return;
	}
	printk("%s:SUCCEED to get regualator handle\n", volname);
	ret = regulator_get_voltage(regu);
	printk("%s:Current voltage is %d\n", volname, ret);

	/* Set output voltage to 3.3v */
	/* Argument: regulator handle, target voltage, Max voltage */
	ret =  regulator_set_voltage(regu, target_vol, max_vol);
	if (ret != 0) {
		printk("%s: Error: some error happen, fail to set regulator voltage!\n", volname);
		goto release_regulator;
	}
	printk("%s:SUCCEED to set voltage\n", volname);
	ret = regulator_get_voltage(regu);
	printk("%s:Current voltage is %d\n", volname, ret);

	/* Enable regulator */
	ret = regulator_enable(regu);
	if (0 != ret) {
		printk("%s: Error: some error happen, fail to enable regulator\n", volname);
		goto release_regulator;
	}

	/* Disable regulator */
	ret = regulator_disable(regu);
	if (0 != ret) {
		printk("%s: Error: some error happen, fail to disable regulator\n", volname);
		goto release_regulator;
	}

release_regulator:
	regulator_put(regu);
}

/*
 * Update new pmu voltage.
 */
void Update_pmu_voltage(void)
{
	/* ALDO1 2.8v */
	set_regulator_voltage("iovdd-csi", 2800000, 2800000);
	/* DLDO3 2.8v */
	set_regulator_voltage("avdd-csi", 2800000, 2800000);
	/* DLDO2 3.3v */
	set_regulator_voltage("vcc-mipi", 3300000, 3300000);
	/* DLDo4 3.3v */
	set_regulator_voltage("vcc-wifi-io", 3300000, 3300000);
}

/* 
 * Get the Wlan gpio information.
 */
static void Wlan_gpio(void)
{
	int ret;
	struct device_node *node;
	const char *string;
	struct gpio_config config;
	unsigned int gpio;

	/* Get device node. */
	node = of_find_node_by_type(NULL, "wlan");
	if (!node) {
		printk("Can't get the node.\n");
	}

	/* Get the string from dts. */
	ret = of_property_read_string(node, "device_type", &string);
	printk("The device type is %s\n", string);
	
	/* Get the gpio information from dts. */
	gpio = of_get_named_gpio_flags(node, "phy_test1", 0, 
			(enum of_gpio_flags *)(unsigned long)&config);
	if (!gpio_is_valid(gpio)) {
		printk(KERN_INFO "Gpio is invalid\n");
		return;
	}
	printk(KERN_INFO "phy_test1 pin=%d\n mul-sel=%d driver %d pull %d data %d gpio %d\n", 
			config.gpio, config.mul_sel, config.drv_level, config.pull,
			config.data, gpio);

	/* Set voltage */
	if (gpio_is_valid(gpio)) {
		printk("GPIO %d is valid\n", gpio);
		gpio_request(gpio, NULL);
		gpio_direction_output(gpio, 1);
		__gpio_set_value(gpio, 1);
	} else
		__gpio_set_value(gpio, 1);

	printk("Current is %d\n", __gpio_get_value(gpio));

}

/*
 * Camera get infromation from device tree.
 */
static void Camera_info(void)
{
	struct device_node *node;
	const char *string;

	node = of_find_node_by_type(NULL, "vfe1");
	if (!node) {
		printk("ERROR: can't get device node\n");
		goto out;
	}

	of_property_read_string(node, "device_type", &string);
	printk("Device type: %s\n", string);

out:
	;

}

/*
 * Get the usbc1 gpio information.
 */
static void usbc1_gpio(void)
{
	int ret;
	struct device_node *node;
	const char *string;
	struct gpio_config config;
	unsigned int gpio;

	/* Get device node. */
	node = of_find_node_by_type(NULL, "usbc1");
	if (!node) {
		printk("Can't get the node.\n");
	}

	/* Get the string from dts. */
	ret = of_property_read_string(node, "device_type", &string);
	printk("The device type is %s\n", string);
	
	/* Get the gpio information from dts. */
	gpio = of_get_named_gpio_flags(node, "usb_drv_vbus_gpio", 0, 
			(enum of_gpio_flags *)(unsigned long)&config);
	if (!gpio_is_valid(gpio)) {
		printk(KERN_INFO "Gpio is invalid\n");
		return;
	}
	printk(KERN_INFO "usb_drv_vbus_gpio pin=%d\n mul-sel=%d driver %d pull %d data %d gpio %d\n", 
			config.gpio, config.mul_sel, config.drv_level, config.pull,
			config.data, gpio);
}

/*
 * open operation
 */
static int buddy_open(struct inode *inode,struct file *filp)
{
	H5_DTS_TEST();
	printk(KERN_INFO "Open device\n");
	return 0;
}
/*
 * write operation
 */
static ssize_t buddy_write(struct file *filp,const char __user *buf,size_t count,loff_t *offset)
{
	printk(KERN_INFO "Write device\n");
	return 0;
}
/*
 *release operation
 */
static int buddy_release(struct inode *inode,struct file *filp)
{
	printk(KERN_INFO "Release device\n");
	return 0;
}
/*
 * read operation
 */
static ssize_t buddy_read(struct file *filp,char __user *buf,size_t count,
		loff_t *offset)
{
	printk(KERN_INFO "Read device\n");
   
	return 0;
}
/*
 * file_operations
 */
static struct file_operations buddy_fops = {
	.owner     = THIS_MODULE,
	.open      = buddy_open,
	.release   = buddy_release,
	.write     = buddy_write,
	.read      = buddy_read,
};
/*
 * misc struct 
 */

static struct miscdevice buddy_misc = {
	.minor    = MISC_DYNAMIC_MINOR,
	.name     = DEV_NAME,
	.fops     = &buddy_fops,
};
/*
 * Init module
 */
static __init int buddy_init(void)
{
	misc_register(&buddy_misc);
	printk("buddy_test\n");
	return 0;
}
/*
 * Exit module
 */
static __exit void buddy_exit(void)
{
	printk(KERN_INFO "buddy_exit_module\n");
	misc_deregister(&buddy_misc);
}
/*
 * module information
 */
module_init(buddy_init);
module_exit(buddy_exit);

MODULE_LICENSE("GPL");
