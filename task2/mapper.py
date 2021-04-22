#!/usr/bin/python

import sys
import re

for line in sys.stdin:
    minecraft = re.search('issued server command: /{1,2}\w+', line)
    if minecraft:
        date = re.search('[0-9]{4}-[0-9]{2}-[0-9]{2}', line)
        if date:
            print "%s %s\t%d" % (date.group(0),minecraft.group(0).split('issued server command: ')[1], 1)
