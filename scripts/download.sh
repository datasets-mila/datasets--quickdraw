#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

export PATH="${PATH}:bin"

! python3 -m pip install --no-cache-dir -U crcmod

mkdir -p raw/ simplified/ binary/ numpy_bitmap/

gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
	cp -R "gs://quickdraw_dataset/full/raw/*.ndjson" raw/
git-annex add raw/
gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
	cp -R "gs://quickdraw_dataset/full/simplified/*.ndjson" simplified/
git-annex add simplified/
gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
	cp -R "gs://quickdraw_dataset/full/binary/*.bin" binary/
git-annex add binary/
gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
	cp -R "gs://quickdraw_dataset/full/numpy_bitmap/*.npy" numpy_bitmap/
git-annex add numpy_bitmap/

md5sum raw/* simplified/* binary/* numpy_bitmap/* > md5sums
