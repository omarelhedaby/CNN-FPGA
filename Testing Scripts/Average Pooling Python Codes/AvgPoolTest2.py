import numpy as np
import skimage.measure

path="C:/Users/ahmed/Desktop/Logic Design 2 Project/Conv1Filters/"
filename="ResultConv2.txt"
file = open(path+filename,'r')
image = np.zeros((10, 10, 16))

if (file.mode=="r"):
    content=file.readlines()
    for idx,num in enumerate(content):
        num.replace('\n','')
        numList = num.split(",")
        row = int(idx/10)%10
        column = idx%10
        depth = int(idx/100)
        for i in range(16):
            image[row,column,i] = float(numList[i])

def AvgPoolSingle(input):
    return skimage.measure.block_reduce(input, (2, 2), np.mean)

AvgPool = np.zeros((5, 5, 16))
j = 15
for i in range(16):
    AvgPool[0:,0:,i] = AvgPoolSingle(image[0:,0:,i])
    j = j - 1


for j in range(16):
    for i in AvgPool[0:,0:,j]:
        for k in i:
            print(k)