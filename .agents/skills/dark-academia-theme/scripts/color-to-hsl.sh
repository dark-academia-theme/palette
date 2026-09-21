#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    printf 'Usage: %s <RRGGBB|#RRGGBB>\n' "${0##*/}" >&2
    exit 64
fi

color=$1
case "$color" in
    \#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]) ;;
    [0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])
        color="#$color"
        ;;
    *)
        printf 'Invalid sRGB color: %s\n' "$color" >&2
        exit 65
        ;;
esac

if ! command -v magick >/dev/null 2>&1; then
    printf 'ImageMagick magick is required.\n' >&2
    exit 69
fi

magick "xc:$color" -colorspace HSL \
    -format 'hsl(%[fx:round(360*u.r)], %[fx:round(100*u.g)]%%, %[fx:round(100*u.b)]%%)\n' \
    info:
