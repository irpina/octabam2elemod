#!/usr/bin/env bash
# How this repository's .elemod files were made, to make them again.
#
# Needs (Linux or WSL):
#   - an elekloader checkout (https://github.com/irpina/elekloader), main;
#   - an octabam checkout at the commit below, with its submodules, and its
#     `make setup` done: the USB IO remixes run octabam's own build, which
#     needs its DSP assembler (vendor/dsp56300 .../dsp_asm);
#   - GNU binutils for m68k-elf (octabam's toolchain) on the PATH:
#     configure --target=m68k-elf; make all-gas all-ld all-binutils;
#   - your own stock OCTATRACK_OS1.40C.syx.
#
#   ./convert.sh ELEKLOADER OCTABAM OCTATRACK_OS1.40C.syx OUT
#
# OUT gets one folder and one .elemod per mod, plus the core (OUT/core). Every
# line of output says CONVERTED (with what was checked), REFUSED or FAILED.
# The .elemod files carry no Elektron bytes, but OUT's folders carry octabam's
# sources, and the remix folders' mod.json files name stock bytes, so share
# the .elemod files only.
set -euo pipefail
EL=$1 OB=$2 STOCK=$3 OUT=$4
COMMIT=363861e

test "$(git -C "$OB" rev-parse --short=7 HEAD)" = "$COMMIT" \
  || { echo "octabam must be at $COMMIT" >&2; exit 1; }
export ELEKLOADER_CROSS=m68k-elf-

cd "$EL"
# the 22 modules that convert on their own (the rest are refused, with the reason)
python3 -m elekloader.sdk.octabam --octabam "$OB" --stock "$STOCK" --out "$OUT"
# USB AUDIO IN converts only as part of a remix: octabam's twelve usb-io remixes
remixes=()
for r in $(ls "$OB/remixes/test" | grep '^usb-io-'); do remixes+=(--remix "$r"); done
python3 -m elekloader.sdk.octabam --octabam "$OB" --stock "$STOCK" --out "$OUT" "${remixes[@]}"
