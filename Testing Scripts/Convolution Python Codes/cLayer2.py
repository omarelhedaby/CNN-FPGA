import numpy as np

path="C:/Users/ahmed/Desktop/Logic Design 2 Project/Conv1Filters/"
filename="AvgPool1Results.txt"
file = open(path+filename,'r')
image = np.zeros((14, 14, 6))

if (file.mode=="r"):
    content=file.readlines()
    for idx,num in enumerate(content):
        num.replace('\n','')
        numList = num.split(",")
        val1 = np.float16(numList[5])
        val2 = np.float16(numList[4])
        val3 = np.float16(numList[3])
        val4 = np.float16(numList[2])
        val5 = np.float16(numList[1])
        val6 = np.float16(numList[0])
        row = int(idx/14)
        column = idx%14
        image[row, column, 0] = val1
        image[row, column, 1] = val2
        image[row, column, 2] = val3
        image[row, column, 3] = val4
        image[row, column, 4] = val5
        image[row, column, 5] = val6


pathF="C:/Users/ahmed/Desktop/Logic Design 2 Project/Parameters With No Seperators/"
filenameF1="filtersconv2d_2.txt"
fileF = open(pathF+filenameF1,'r')
filter = np.zeros((5,5,6,16))

if (file.mode=="r"):
    contentF=fileF.readlines()
    for idx,W in enumerate(contentF):
        W.replace('\n','')
        valF=np.float16(W)
        rowF = int(idx/5)%5
        columnF = idx%5
        depth = int(idx/25)%6
        filterno = int (idx/150)
        filter[rowF,columnF,depth,filterno] = valF

print(filter)

def conv(img, fltr,size):
    outC = np.float16(0)
    for i in range(size):
        for j in range(size):
            outC += img[i,j] * fltr[i,j]
    return outC

cLayerOut = np.zeros((10,10,16))
fileW = open(pathF+"Result.txt",'w')

def conv3d(img,fltr,size):
    outC = 0
    for i in range(size):
        outC += conv(img[0:,0:,i],fltr[0:,0:,i],5)
    return outC

for k in range(16):
    for i in range(10):
        for j in range(10):
            recF = image[i:i+5,j:j+5,0:]
            SLout= conv3d(recF,filter[0:,0:,0:,k],6)
            cLayerOut[i,j,k] = SLout
            fileW.write(str(SLout) + "\n")



fileW.close()
