#!/usr/bin/env python

import sys
import subprocess
import re

if len(sys.argv) < 3:
  sys.exit(1)

nodeNumID = sys.argv[1]
nodeType = sys.argv[2]

if not nodeType in ["storage", "meta", "metadata"]:
  sys.exit(1)

cmd = ["fhgfs-ctl", "--listpools", '--nodetype=%s' % nodeType]

process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# wait for the process to terminate
#out, err = process.communicate()
errcode = process.returncode

status = ''
for line in process.stdout:
  str = re.sub(r'\s+', '|', line)
  match = re.search(r'^\|%s\|\[(.*)\]' % nodeNumID, str)
  if match:
    status = match.group(1)
    break

print(status)

sys.exit(errcode)

