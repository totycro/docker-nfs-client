#!/bin/sh -ex

cleanup() {
    SIGNAL=$1
    echo "Caught $SIGNAL, cleaning up"

    umount "$MOUNT_POINT" || true

    while mount | grep " $FSTYPE " | grep "$MOUNT_POINT"; do
        echo "Unmounting failed, possibly other processes are accessing the share."
        echo "Assuming that those will be killed and retrying repeatedly."

        sleep 1
        umount "$MOUNT_POINT" || true
        umount -f "$MOUNT_POINT" || true
    done

    # cleanup trap
    trap - $SIGNAL
    exit $?
}

mkdir -p "$MOUNT_POINT"

trap "cleanup INT" INT
trap "cleanup TERM" TERM

# NOTE: not starting rpcbind, apparently nfs4 can cope without it
mount -t "$FSTYPE" -o "$MOUNT_OPTIONS" "$MOUNT_TARGET" "$MOUNT_POINT"

# NOTE: due to -e, this makes the script fail if the mount is not present
mount | grep " $FSTYPE " | grep "$MOUNT_POINT"

tail -f /dev/null
