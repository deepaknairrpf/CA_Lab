from prettytable import PrettyTable
import random

table = PrettyTable(['Iteration', 'Prediction Bit','Actual Outcome','Update'])
table2= PrettyTable(['Iteration', 'Prediction Bit','Actual Outcome'])
P_B = 'NT'
# A_O = ['T','NT']
Outcomes = ['T','NT']
# random.choice(A_O)
A_O = []
A_O2=[]
P_B2=[]
U = ''
No = raw_input("Number of iterations: ")
No = int(No)
Correct = 0 

correct2=0

for i in range(0,No):
	row = []
	row2=[]
	A_O.append(random.choice(Outcomes))
	row.append(str(i + 1))
	row2.append(str(i + 1))
	row.append(P_B)
	row.append(A_O[i])
	if(A_O[i] == 'T'):
		U = 'T'
	else:
		U = 'NT'
	if(A_O[i] == P_B):
		Correct = Correct + 1
	row.append(U)
	table.add_row(row)

	P_B2 = A_O[i]
	row2.append(P_B2)
	A_O2.append(A_O[i])
	row2.append(A_O2[i])

	if(A_O2[i] == 'T'):
		U = 'T'
	else:
		U = 'NT'
	if(A_O2[i] == P_B2):
		correct2 = correct2 + 1
	#row.append(U)
	#table.add_row(row)

	P_B = U


	table2.add_row(row2)




print(table)

print(table2)

per = float(Correct)/float(No)*100
print("Accuracy of prediction of lopp 1 is " + str(per) + " %")

per2=float(correct2)/float(No)*100
print("Accuracy of prediction of lopp 2 is " + str(per2) + " %")