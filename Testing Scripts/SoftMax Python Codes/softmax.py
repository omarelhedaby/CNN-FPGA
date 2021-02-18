import struct
from math import exp,factorial
import numpy as np

def float_to_bin(num):
    bits, = struct.unpack('!I', struct.pack('!f', num))
    return "{:032b}".format(bits)

def taylor(num,iter):
    sum=1
    for i in range(1,iter+1):
        sum=sum+(num**i/factorial(i))
    return sum
DATA_WIDTH=32
# input is 0.2 -0.2 1.2 1.3 -0.9 0.3 3.1 -0.02 1.11 0.323

if __name__ == '__main__':
    numbers=[]
    expReal=[]
    expTay=[]
    input1="0.2 -0.2 1.2 1.3 -0.9 0.3 3.1 -0.02 1.11 0.323"
    file=open('log.txt',"w")
    string=input1
    string=string.split(" ")
    for i in string:
        numbers.append(float(i))
    file.write("Input is : \n")
    for i  in range(0,10):
        IEEE=float_to_bin(numbers[i])
        IEEE=int(IEEE,2)
        IEEE=bin(IEEE)
        str=IEEE.split("0b")[1]
        for i in range(DATA_WIDTH, len(str),-1):
            str='0'+str
        file.write(str)
    file.write("\n")
    for j in range(0,10):
        expTay.append(taylor(numbers[j],6))
    expReal=np.exp(numbers)
    print("Real exp: {}".format(expReal))
    print("Tay exp: {}".format(expTay))
    sumReal=np.sum(expReal)
    sumTay=np.sum(expTay)
    print("The real sum is {} and the taylor sum is {} ".format(sumReal,sumTay))
    softReal=expReal/sumReal
    softTay=expTay/sumTay
    print("Real Softmax is {}".format(softReal))
    print("Tay Softmax is {}".format(softTay))
    file.write("The Output is: \n")
    for i in range(0,10):
        IEEE = float_to_bin(softTay[i])
        IEEE = int(IEEE, 2)
        IEEE = bin(IEEE)
        str = IEEE.split("0b")[1]
        for i in range(DATA_WIDTH, len(str),-1):
            str='0'+str
        file.write(str+"_")
    file.close()





