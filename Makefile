export O := build_4b
export ARCH := arm64
export LLVM := -17

2024-03-12-raspios-bookworm-arm64-lite.img:
	@curl -sfL https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2024-03-13/$@.xz | xz -d - > $@

linux_raspberrypi/$(O)/arch/$(ARCH)/boot/Image:
	@$(MAKE) -C linux_raspberrypi bcm2711_rust_defconfig
	@$(MAKE) -C linux_raspberrypi

.PHONY: build
build: linux_raspberrypi/$(O)/arch/$(ARCH)/boot/Image