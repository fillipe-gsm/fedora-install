# Mount an MTP phone connected over USB and open it in yazi.
#
# gvfs only exposes MTP after an explicit `gio mount`, and yazi is not a GIO
# client, so the FUSE path under /run/user/<uid>/gvfs must exist before yazi
# can open it. File managers (Thunar/Nautilus) mount on click; this does the
# same thing from the shell.
#
# Usage: motorola_mount [usb-vendor-id]
#   motorola_mount        # Motorola (22b8)
#   motorola_mount 04e8   # e.g. Samsung
function motorola_mount --description 'Mount MTP phone and open it in yazi'
    set -l vendor 22b8
    if test (count $argv) -gt 0
        set vendor $argv[1]
    end

    set -l line (lsusb -d $vendor: 2>/dev/null | head -n 1)
    if test -z "$line"
        echo "motorola_mount: no USB device with vendor $vendor found (connected, unlocked, in file transfer mode?)" >&2
        return 1
    end

    # string match -r prints the full match first, then the capture groups.
    set -l ids (string match -r '^Bus (\d+) Device (\d+)' -- $line)
    set -l bus $ids[2]
    set -l dev $ids[3]

    # Mount by ID_SERIAL when possible: gvfs then names the mount after the
    # device instead of the bus/device pair, so the path survives replugging.
    set -l serial (udevadm info -q property -n /dev/bus/usb/$bus/$dev 2>/dev/null \
        | string match 'ID_SERIAL=*' | string replace 'ID_SERIAL=' '')

    set -l uri "mtp://[usb:$bus,$dev]/"
    if test -n "$serial"
        set uri "mtp://$serial/"
    end

    gio mount $uri 2>/dev/null

    set -l gvfs_root /run/user/(id -u)/gvfs
    set -l dir
    for i in (seq 20)
        if test -n "$serial"
            set dir (find $gvfs_root -maxdepth 1 -name "mtp:host=$serial" -print -quit 2>/dev/null)
        else
            set dir (find $gvfs_root -maxdepth 1 -name 'mtp:host=*' -print -quit 2>/dev/null)
        end
        test -n "$dir"; and break
        sleep 0.25
    end

    if test -z "$dir"
        echo "motorola_mount: MTP mount did not appear under $gvfs_root" >&2
        return 1
    end

    yazi "$dir"
end
