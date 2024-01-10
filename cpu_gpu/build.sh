#!/usr/bin/sh

echo "Cleanig pre-built binaries..."
rm cpu gpu
echo "Building CPU program..." 
gcc -o cpu cpu.c
echo "\"cpu\" is built."
echo "Building GPU program..."
nvcc -o gpu gpu.cu
echo "\"gpu\" is built."
