#!/bin/sh

[ -z "$1" ] && exit 1
filename="$1"

for size in 16 32 48; do
	convert "$filename" -filter Lanczos -thumbnail ${size}x${size} -unsharp 1.5x1+0.7+0.02 "${size}x${size}.png" || exit 1
done

for size in 52 192 70 150 310; do
	convert "$filename" -thumbnail ${size}x${size} -unsharp 12x6+0.5+0 "${size}x${size}.png" || exit 1
done

convert 16x16.png 32x32.png 48x48.png favicon.ico
rm 16x16.png 32x32.png 48x48.png
