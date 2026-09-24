#!/bin/sh
# Turn OFF every monitor under MangoWM.
# Workaround: Noctalia 4.7.7 calls `mmsg -s -d disable_monitor,<name>` (old flag
# syntax) which mango 0.14.4's mmsg rejects ("unknown command"). This uses the
# current `mmsg dispatch disable_monitor,<name>` form and enumerates monitors
# dynamically so it works docked or undocked.
# Wired into Noctalia via idle.screenOffCommand in settings.json.
mmsg get all-monitors 2>/dev/null | python3 -c '
import json, sys, subprocess
try:
    mons = json.load(sys.stdin).get("monitors", [])
except Exception:
    sys.exit(0)
for m in mons:
    subprocess.run(["mmsg", "dispatch", "disable_monitor," + m["name"]])
'
