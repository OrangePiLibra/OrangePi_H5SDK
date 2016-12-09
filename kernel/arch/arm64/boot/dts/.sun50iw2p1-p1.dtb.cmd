cmd_arch/arm64/boot/dts/sun50iw2p1-p1.dtb := /home/orange/extend_space/H5/Linux/lichee/out/sun50iw2p1/dragonboard/common/buildroot/external-toolchain/bin/aarch64-linux-gnu-gcc -E -Wp,-MD,arch/arm64/boot/dts/.sun50iw2p1-p1.dtb.d.pre.tmp -nostdinc -I/home/orange/extend_space/H5/Linux/lichee/linux-3.10/arch/arm64/boot/dts -I/home/orange/extend_space/H5/Linux/lichee/linux-3.10/arch/arm64/boot/dts/include -I/home/orange/extend_space/H5/Linux/lichee/linux-3.10/include -undef -D__DTS__ -x assembler-with-cpp -o arch/arm64/boot/dts/.sun50iw2p1-p1.dtb.dts arch/arm64/boot/dts/sun50iw2p1-p1.dts ; /home/orange/extend_space/H5/Linux/lichee/linux-3.10/scripts/dtc/dtc -O dtb -o arch/arm64/boot/dts/sun50iw2p1-p1.dtb -b 0 -i arch/arm64/boot/dts/  -d arch/arm64/boot/dts/.sun50iw2p1-p1.dtb.d.dtc.tmp arch/arm64/boot/dts/.sun50iw2p1-p1.dtb.dts ; cat arch/arm64/boot/dts/.sun50iw2p1-p1.dtb.d.pre.tmp arch/arm64/boot/dts/.sun50iw2p1-p1.dtb.d.dtc.tmp > arch/arm64/boot/dts/.sun50iw2p1-p1.dtb.d

source_arch/arm64/boot/dts/sun50iw2p1-p1.dtb := arch/arm64/boot/dts/sun50iw2p1-p1.dts

deps_arch/arm64/boot/dts/sun50iw2p1-p1.dtb := \
  arch/arm64/boot/dts/sun50iw2p1.dtsi \
  /home/orange/extend_space/H5/Linux/lichee/linux-3.10/include/dt-bindings/interrupt-controller/arm-gic.h \
  /home/orange/extend_space/H5/Linux/lichee/linux-3.10/include/dt-bindings/interrupt-controller/irq.h \
  /home/orange/extend_space/H5/Linux/lichee/linux-3.10/include/dt-bindings/gpio/gpio.h \
  arch/arm64/boot/dts/sun50iw2p1-clk.dtsi \
  arch/arm64/boot/dts/sun50iw2p1-pinctrl.dtsi \

arch/arm64/boot/dts/sun50iw2p1-p1.dtb: $(deps_arch/arm64/boot/dts/sun50iw2p1-p1.dtb)

$(deps_arch/arm64/boot/dts/sun50iw2p1-p1.dtb):
