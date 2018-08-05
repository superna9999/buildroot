################################################################################
#
# aml-s905x-cc-fip
#
################################################################################

AML_S905X_CC_FIP_VERSION = 20170606
AML_S905X_CC_FIP_SOURCE = libretech-cc_fip_$(AML_S905X_CC_FIP_VERSION).tar.gz
AML_S905X_CC_FIP_SITE = https://github.com/BayLibre/u-boot/releases/download/v2017.11-libretech-cc
AML_S905X_CC_FIP_LICENSE = Amlogic

AML_S905X_CC_FIP_INSTALL_IMAGES = YES

define AML_S905X_CC_FIP_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/gxl/bl2.bin $(BINARIES_DIR)/fip/bl2.bin
	$(INSTALL) -D -m 0644 $(@D)/gxl/acs.bin $(BINARIES_DIR)/fip/acs.bin
	$(INSTALL) -D -m 0644 $(@D)/gxl/bl21.bin $(BINARIES_DIR)/fip/bl21.bin
	$(INSTALL) -D -m 0644 $(@D)/gxl/bl30.bin $(BINARIES_DIR)/fip/bl30.bin
	$(INSTALL) -D -m 0644 $(@D)/gxl/bl301.bin $(BINARIES_DIR)/fip/bl301.bin
	$(INSTALL) -D -m 0644 $(@D)/gxl/bl31.img $(BINARIES_DIR)/fip/bl31.img
	$(INSTALL) -D -m 0755 $(@D)/gxl/aml_encrypt_gxl $(BINARIES_DIR)/fip/aml_encrypt_gxl
	$(INSTALL) -D -m 0755 $(@D)/blx_fix.sh $(BINARIES_DIR)/fip/blx_fix.sh
	$(INSTALL) -D -m 0644 $(@D)/acs_tool.pyc $(BINARIES_DIR)/fip/acs_tool.pyc
endef

$(eval $(generic-package))
