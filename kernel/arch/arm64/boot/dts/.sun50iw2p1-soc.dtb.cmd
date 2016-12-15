cmd_arch/arm64/boot/dts/sun50iw2p1-soc.dtb := /home/orange/OPEN_SOURCE/OrangePi_H5SDK/toolchain/gcc-linaro-aarch/bin/aarch64-linux-gnu-gcc -E -Wp,-MD,arch/arm64/boot/dts/.sun50iw2p1-soc.dtb.d.pre.tmp -nostdinc -I/home/orange/OPEN_SOURCE/OrangePi_H5SDK/kernel/arch/arm64/boot/dts -I/home/orange/OPEN_SOURCE/OrangePi_H5SDK/kernel/arch/arm64/boot/dts/include -I/home/orange/OPEN_SOURCE/OrangePi_H5SDK/kernel/include -undef -D__DTS__ -x assembler-with-cpp -o arch/arm64/boot/dts/.sun50iw2p1-soc.dtb.dts arch/arm64/boot/dts/sun50iw2p1-soc.dts ; /home/orange/OPEN_SOURCE/OrangePi_H5SDK/kernel/scripts/dtc/dtc -O dtb -o arch/arm64/boot/dts/sun50iw2p1-soc.dtb -b 0 -i arch/arm64/boot/dts/  -d arch/arm64/boot/dts/.sun50iw2p1-soc.dtb.d.dtc.tmp arch/arm64/boot/dts/.sun50iw2p1-soc.dtb.dts ; cat arch/arm64/boot/dts/.sun50iw2p1-soc.dtb.d.pre.tmp arch/arm64/boot/dts/.sun50iw2p1-soc.dtb.d.dtc.tmp > arch/arm64/boot/dts/.sun50iw2p1-soc.dtb.d

source_arch/arm64/boot/dts/sun50iw2p1-soc.dtb := arch/arm64/boot/dts/sun50iw2p1-soc.dts

deps_arch/arm64/boot/dts/sun50iw2p1-soc.dtb := \
  arch/arm64/boot/dts/sun50iw2p1.dtsi \
  /home/orange/OPEN_SOURCE/OrangePi_H5SDK/kernel/include/dt-bindings/interrupt-controller/arm-gic.h \
  /home/orange/OPEN_SOURCE/OrangePi_H5SDK/kernel/include/dt-bindings/interrupt-controller/irq.h \
  /home/orange/OPEN_SOURCE/OrangePi_H5SDK/kernel/include/dt-bindings/gpio/gpio.h \
  arch/arm64/boot/dts/sun50iw2p1-clk.dtsi \
  arch/arm64/boot/dts/sun50iw2p1-pinctrl.dtsi \

arch/arm64/boot/dts/sun50iw2p1-soc.dtb: $(deps_arch/arm64/boot/dts/sun50iw2p1-soc.dtb)

$(deps_arch/arm64/boot/dts/sun50iw2p1-soc.dtb):
