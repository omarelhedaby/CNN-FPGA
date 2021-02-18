import numpy as np
import skimage.measure

path="C:/Users/ahmed/Desktop/Logic Design 2 Project/Conv1Filters/"
filename="ResultConv1.txt"
file = open(path+filename,'r')
image = np.zeros((28, 28, 6))

if (file.mode=="r"):
    content=file.readlines()
    for idx,num in enumerate(content):
        num.replace('\n','')
        numList = num.split(",")
        val1 = float(numList[0])
        val2 = float(numList[1])
        val3 = float(numList[2])
        val4 = float(numList[3])
        val5 = float(numList[4])
        val6 = float(numList[5])
        row = int(idx/28)
        column = idx%28
        image[row,column,0] = val1
        image[row, column, 1] = val2
        image[row, column, 2] = val3
        image[row, column, 3] = val4
        image[row, column, 4] = val5
        image[row, column, 5] = val6

def AvgPoolSingle(input):
    return skimage.measure.block_reduce(input, (2, 2), np.mean)

Av1 = AvgPoolSingle(image[0:,0:,5])
Av2 = AvgPoolSingle(image[0:,0:,4])
Av3 = AvgPoolSingle(image[0:,0:,3])
Av4 = AvgPoolSingle(image[0:,0:,2])
Av5 = AvgPoolSingle(image[0:,0:,1])
Av6 = AvgPoolSingle(image[0:,0:,0])

for i in Av1:
    for j in i:
        print(j)

for i in Av2:
    for j in i:
        print(j)

for i in Av3:
    for j in i:
        print(j)

for i in Av4:
    for j in i:
        print(j)

for i in Av5:
    for j in i:
        print(j)

for i in Av6:
    for j in i:
        print(j)