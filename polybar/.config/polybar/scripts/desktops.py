#!/usr/bin/env python

import json

from subprocess import Popen, PIPE

cmd = Popen(['/usr/bin/i3-msg', '-t', 'get_workspaces'], stdout=PIPE)
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
