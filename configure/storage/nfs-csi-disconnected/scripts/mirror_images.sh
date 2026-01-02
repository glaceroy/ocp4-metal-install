#!/bin/bash
LOCAL_REG="registry.cloud.lab:8443"
SCRIPT_DIR=$(dirname "$0")
cd $SCRIPT_DIR
while read IMAGE; do
    IMAGE=$(echo $IMAGE | tr -d '"')
    IMAGE_NAME=$(basename $IMAGE | cut -d':' -f1)
    IMAGE_TAG=$(echo $IMAGE | cut -d':' -f2)
    TARGET_IMAGE="$LOCAL_REG/csi-nfs/$IMAGE_NAME:$IMAGE_TAG"
    echo "Mirroring $IMAGE -> $TARGET_IMAGE"
    podman pull $IMAGE
    podman tag $IMAGE $TARGET_IMAGE
    podman push $TARGET_IMAGE
done < images.txt
