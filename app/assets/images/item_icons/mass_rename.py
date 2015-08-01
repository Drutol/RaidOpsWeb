import os

name_dictionary = {}
names = []
os.chdir("/home/drutol/icons/out")
with open('name_pairs.txt') as f:
    names = f.read().splitlines()

for line in names:
	params = line.split(':')
	name_dictionary[params[1]] = params[0]


for filename in os.listdir("/home/drutol/icons/out"):
	new_name = name_dictionary.get(filename,"nope")
	if new_name != "nope":
		os.rename(filename, new_name)