#!/bin/sh
# Turn ON every monitor under MangoWM (companion to screen-off.sh).
# Wired into Noctalia via idle.resumeScreenOffCommand in settings.json.
mmsg get all-monitors 2>/dev/null | python3 -c '
import json, sys, subprocess
try:
    mons = json.load(sys.stdin).get("monitors", [])
except Exception:
    sys.exit(0)
for m in mons:
    subprocess.run(["mmsg", "dispatch", "enable_monitor," + m["name"]])
'
