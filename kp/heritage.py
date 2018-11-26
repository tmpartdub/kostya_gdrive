import os
f = open('481086621_1_DF_1283f3i5jw0aa515.ged')
people = {}
line = f.readline().split()
while len(line)>0:
	if len(line)<3:
		pass
	elif line[2] == 'INDI':
		no = line[1]
		while (line[1] != 'GIVN'):
			line = f.readline().split()
		name = line[2]
		while (line[1] != 'SURN'):
			line = f.readline().split()
		surname = line[2]
		while (line[1] != 'SEX'):
			line = f.readline().split()
		sex = line[2]
		people[no] = '"'+name+' '+surname+'"'
		if sex=='F':
			print('female({0}).'.format(people[no]))
		else:
			print('male({0}).'.format(people[no]))

	elif line[2] == 'FAM':
		wife = ""
		husbando = ""
		line = f.readline().split()
		line = f.readline().split()
		if line[1] == 'HUSB':
			husbando = people[line[2]]
			line = f.readline().split()
		if line[1] == 'WIFE':			
			wife = people[line[2]]
			line = f.readline().split()
		while (line[1] == 'CHIL'):
			if len(wife)>0:
				print("child({0}, {1}).".format(people[line[2]], wife))
			if husbando:
				print("child({0}, {1}).".format(people[line[2]], husbando))
			line = f.readline().split()


	line = f.readline().split()


# for namae in people.values() :
# 	if namae[2]=='F':
# 		print('female({0}).'.format('"'+namae[0]+' '+namae[1]+'"'))
# 	elif namae[2]=='M':
# 		print('male({0}).'.format('"'+namae[0]+' '+namae[1]+'"'))

