import sys, Core
from math import *

if(len(sys.argv)!=2):
	print "Usage: python . <case>"
	sys.exit(1);

try:
	inputlines = open(sys.argv[1],'r').readlines()[1:]
except IOError:
	print "%s: no such file or directory"%sys.argv[1]
	sys.exit(1);

def getSetTag(hexa):
	bina = bin(int(hexa,16))[2:].zfill(32)
	s,t = 0,0
	for bit in bina[0:20]:
		t = t*2 + int(bit);
	for bit in bina[20:26]:
		s = s*2 + int(bit);
	return [s,t]

def handler(result, trace, c0, c1, c2, c3):
	addr = getSetTag(trace[2])
	blockFound = 0
	response = c1.request(addr[0], addr[1], 'BR')
	if response:
		if len(result) == 2:
			c0.change(addr[0], addr[1], 'S')
		elif len(result) == 1:
			c0.new(addr[0], addr[1], 'S')
		blockFound = 1
	response = c2.request(addr[0], addr[1], 'BR')
	if response:
		if len(result) == 2 :
			c0.change(addr[0], addr[1], 'S')
		elif len(result) == 1:
			c0.new(addr[0], addr[1], 'S')
		blockFound = 1
	response = c3.request(addr[0], addr[1], 'BR')
	if response:
		if len(result) == 2:
			c0.change(addr[0], addr[1], 'S')
		elif len(result) == 1:
			c0.new(addr[0], addr[1], 'S')
		blockFound = 1
	if blockFound == 0:
		if len(result) == 2:
			c0.change(addr[0], addr[1], 'E')
		elif len(result) == 1:
			c0.new(addr[0], addr[1], 'E')
	return (c0, c1, c2, c3)

def execute(trace):
	buf = trace[0]
	rw = trace[1]
	addr = getSetTag(trace[2])

	if buf == '0':
		if rw == '0':
			result = core[1].read(addr[0], addr[1])
			if len(result) != 0:
				(core[1], core[2], core[3], core[4]) = handler(result, trace, core[1], core[2], core[3], core[4])
		elif rw == '1':
			result = core[1].write(addr[0], addr[1])
			core[2].change(addr[0], addr[1], 'I')
			core[3].change(addr[0], addr[1], 'I')
			core[4].change(addr[0], addr[1], 'I')
	if buf == '1':
		if rw == '0':
			result = core[2].read(addr[0], addr[1])
			if len(result) != 0:
				(core[2], core[1], core[3], core[4]) = handler(result, trace, core[2], core[1], core[3], core[4])
		elif rw == '1':
			result = core[2].write(addr[0], addr[1])
			core[1].change(addr[0], addr[1], 'I')
			core[3].change(addr[0], addr[1], 'I')
			core[4].change(addr[0], addr[1], 'I')
	if buf == '2':
		if rw == '0':
			result = core[3].read(addr[0], addr[1])
			if len(result) != 0:
				(core[3], core[2], core[1], core[4]) = handler(result, trace, core[3], core[2], core[1], core[4])
		elif rw == '1':
			result = core[3].write(addr[0], addr[1])
			core[2].change(addr[0], addr[1], 'I')
			core[1].change(addr[0], addr[1], 'I')
			core[4].change(addr[0], addr[1], 'I')
	if buf == '3':
		if rw == '0':
			result = core[4].read(addr[0], addr[1])
			if len(result) != 0:
				(core[4], core[2], core[3], core[1]) = handler(result, trace, core[4], core[2], core[3], core[1])
		elif rw == '1':
			result = core[4].write(addr[0], addr[1])
			core[2].change(addr[0], addr[1], 'I')
			core[3].change(addr[0], addr[1], 'I')
			core[1].change(addr[0], addr[1], 'I')

def printStats():
	core[1].printStats("One")
	core[2].printStats("Two")
	core[3].printStats("Three")
	core[4].printStats("Four")

core = [0, Core.Core(), Core.Core(), Core.Core(), Core.Core()]
for i in inputlines:
	execute(i.strip().split()[1:])
print ""
printStats()
