import numpy as np

path="C:/Users/ahmed/Desktop/Logic Design 2 Project/"
filename="Digit-0-Index1.txt"
file = open(path+filename,'r')
image = np.zeros((32, 32))

if (file.mode=="r"):
    content=file.readlines()
    for idx,num in enumerate(content):
        num.replace('\n','')
        val=float(num)
        row = int(idx/32)
        column = idx%32
        image[row,column] = val

pathF="C:/Users/ahmed/Desktop/Logic Design 2 Project/"
filenameF1="c1f1.txt"
filenameF2="c1f2.txt"
filenameF3="c1f3.txt"
filenameF4="c1f4.txt"
filenameF5="c1f5.txt"
filenameF6="c1f6.txt"
fileF1 = open(pathF+filenameF1,'r')
fileF2 = open(pathF+filenameF2,'r')
fileF3 = open(pathF+filenameF3,'r')
fileF4 = open(pathF+filenameF4,'r')
fileF5 = open(pathF+filenameF5,'r')
fileF6 = open(pathF+filenameF6,'r')
filter1 = np.zeros((5, 5))
filter2 = np.zeros((5, 5))
filter3 = np.zeros((5, 5))
filter4 = np.zeros((5, 5))
filter5 = np.zeros((5, 5))
filter6 = np.zeros((5, 5))

if (fileF5.mode=="r"):
    contentF=fileF5.readlines()
    for idx,W in enumerate(contentF):
        W.replace('\n','')
        valF=float(W)
        rowF = int(idx/5)
        columnF = idx%5
        filter5[rowF,columnF] = valF

if (fileF6.mode=="r"):
    contentF=fileF6.readlines()
    for idx,W in enumerate(contentF):
        W.replace('\n','')
        valF=float(W)
        rowF = int(idx/5)
        columnF = idx%5
        filter6[rowF,columnF] = valF

print(filter)

def conv(img, fltr,size):
    outC = 0
    for i in range(size):
        for j in range(size):
            outC += img[i,j] * fltr[i,j]
    return outC

cLayerOut = np.zeros((56,28))
fileW = open(pathF+"Result.txt",'w')

def conv3d(img,fltr,size):
    outC = 0
    for i in range(size):
        outC += conv(img[0:,0:,i],fltr[0:,0:,i],5)

fileW.write("D:0\n")

for i in range(28):
    for j in range(28):
        recF = image[i:i+5,j:j+5]
        SLout= conv(recF,filter5,5)
        cLayerOut[i,j] = SLout
        fileW.write(str(SLout) + "\n")

fileW.write("D:1\n")

for i in range(28):
    for j in range(28):
        recF = image[i:i+5,j:j+5]
        SLout= conv(recF,filter6,5)
        cLayerOut[i,j] = SLout
        fileW.write(str(SLout) + "\n")

fileW.close()
