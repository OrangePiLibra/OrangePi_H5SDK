#!/bin/sh

set -e

cat > "/etc/modules-load.d/OrangePi_Camera.conf" << EOF
videobuf2-core
videobuf2-memops
videobuf2-dma-contig
vfe_io
gc2035
vfe_v4l2
EOF
