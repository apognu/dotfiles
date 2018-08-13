#!/usr/bin/env python

import sys
import subprocess

I3_MSG='/usr/bin/i3-msg'

if len(sys.argv) > 1:
  if sys.argv[1] == 'down':
    subprocess.run([I3_MSG, 'workspace', 'next_on_output'])
  elif sys.argv[1] == 'up':
    subprocess.run([I3_MSG, 'workspace', 'prev_on_output'])
  
  sys.exit(0)

import json

cmd = subprocess.Popen([I3_MSG, '-t', 'get_workspaces'], stdout=subprocess.PIPE)
stdout, _= cmd.communicate()
out = json.loads(stdout)

workspaces = list(map(lambda w: w['num'], out))
active = [w['num'] for w in out if w['focused']]
active = active[0] if len(active) > 0 else None

for x in range(1, 11):
  if x in workspaces:
    if x == active:
      print('', end=' ')
    else:
      print('', end=' ')
  else:
    print('', end=' ')
