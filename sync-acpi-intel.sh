#!/bin/bash
# Copyright (c) 2011, Michel Alexandre Salim <salimma@fedoraproject.org>
# Permission is hereby granted, without written agreement and without
# license or royalty fees, to use, copy, modify, and distribute this
# software and its documentation for any purpose, provided that the
# above copyright notice and the following two paragraphs appear in
# all copies of this software.
#
# IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE TO ANY PARTY FOR
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
# ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
# IF THE COPYRIGHT HOLDER HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
# DAMAGE.
#
# THE COPYRIGHT HOLDER SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING,
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
# ON AN "AS IS" BASIS, AND THE COPYRIGHT HOLDER HAS NO OBLIGATION TO
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

BACKLIGHT_DIR=/sys/class/backlight
ACPI=${BACKLIGHT_DIR}/acpi_video0
INTEL=${BACKLIGHT_DIR}/intel_backlight

ACPI_MAX=`cat ${ACPI}/max_brightness`
INTEL_MAX=`cat ${INTEL}/max_brightness`
# this is about 500
#MULTIPLIER=$((INTEL_MAX/(ACPI_MAX+1)))
MULTIPLIER=500
MIN_BRIGHTNESS=$((INTEL_MAX-(MULTIPLIER*ACPI_MAX)))

function fib {
    let a=$1
    let b=$2
    let n=$3

    if [ $n == 0 ]; then
        INTEL_BRIGHTNESS=$a
    else
        fib $b $((a + b)) $((n-1))
    fi
}

while inotifywait -e modify ${ACPI}/brightness >/dev/null 2>&1; do
    BRIGHTNESS=`cat ${ACPI}/brightness`
    # specially handle maximum value
    if [ ${BRIGHTNESS} == ${ACPI_MAX} ]; then
        INTEL_BRIGHTNESS=$INTEL_MAX
    else
        # arithmetic
        INTEL_BRIGHTNESS=$((MULTIPLIER*(BRIGHTNESS+1)))
        # geometric
        #INTEL_BRIGHTNESS=$((INTEL_MAX >> (8-BRIGHTNESS)))
        #INTEL_BRIGHTNESS=$((25 << BRIGHTNESS))
        #fibonacci
        #fib 100 200 $(BRIGHTNESS)
  fi
  echo ${INTEL_BRIGHTNESS} > ${INTEL}/brightness
done
