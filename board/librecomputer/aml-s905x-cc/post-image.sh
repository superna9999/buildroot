#!/bin/sh

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

mkdir ${BINARIES_DIR}/fip/tmp
cp ${BINARIES_DIR}/u-boot.bin ${BINARIES_DIR}/fip/tmp/bl33.bin
cp ${BINARIES_DIR}/fip/bl31.img ${BINARIES_DIR}/fip/tmp/bl31.img

${BINARIES_DIR}/fip/blx_fix.sh ${BINARIES_DIR}/fip/bl30.bin \
		${BINARIES_DIR}/fip/tmp/zero_tmp \
		${BINARIES_DIR}/fip/tmp/bl30_zero.bin \
		${BINARIES_DIR}/fip/bl301.bin \
		${BINARIES_DIR}/fip/tmp/bl301_zero.bin \
		${BINARIES_DIR}/fip/tmp/bl30_new.bin bl30

python ${BINARIES_DIR}/fip/acs_tool.pyc ${BINARIES_DIR}/fip/bl2.bin \
		${BINARIES_DIR}/fip/tmp/bl2_acs.bin \
		${BINARIES_DIR}/fip/acs.bin 0

${BINARIES_DIR}/fip/blx_fix.sh ${BINARIES_DIR}/fip/tmp/bl2_acs.bin \
		${BINARIES_DIR}/fip/tmp/zero_tmp \
		${BINARIES_DIR}/fip/tmp/bl2_zero.bin \
		${BINARIES_DIR}/fip/bl21.bin \
		${BINARIES_DIR}/fip/tmp/bl21_zero.bin \
		${BINARIES_DIR}/fip/tmp/bl2_new.bin bl2

${BINARIES_DIR}/fip/aml_encrypt_gxl --bl3enc \
		--input ${BINARIES_DIR}/fip/tmp/bl30_new.bin

${BINARIES_DIR}/fip/aml_encrypt_gxl --bl3enc \
		--input ${BINARIES_DIR}/fip/tmp/bl31.img

${BINARIES_DIR}/fip/aml_encrypt_gxl --bl3enc \
		--input ${BINARIES_DIR}/fip/tmp/bl33.bin

${BINARIES_DIR}/fip/aml_encrypt_gxl --bl2sig \
		--input ${BINARIES_DIR}/fip/tmp/bl2_new.bin \
		--output ${BINARIES_DIR}/fip/tmp/bl2.n.bin.sig

${BINARIES_DIR}/fip/aml_encrypt_gxl --bootmk \
		--output ${BINARIES_DIR}/fip/tmp/u-boot.bin \
		--bl2 ${BINARIES_DIR}/fip/tmp/bl2.n.bin.sig \
		--bl30 ${BINARIES_DIR}/fip/tmp/bl30_new.bin.enc \
		--bl31 ${BINARIES_DIR}/fip/tmp/bl31.img.enc \
		--bl33 ${BINARIES_DIR}/fip/tmp/bl33.bin.enc

dd if=${BINARIES_DIR}/fip/tmp/u-boot.bin.sd.bin \
   of=${BINARIES_DIR}/sdcard.img \
   bs=1 count=444 conv=sync,notrunc

dd if=${BINARIES_DIR}/fip/tmp/u-boot.bin.sd.bin \
   of=${BINARIES_DIR}/sdcard.img \
   bs=512 skip=1 seek=1 conv=fsync,notrunc
