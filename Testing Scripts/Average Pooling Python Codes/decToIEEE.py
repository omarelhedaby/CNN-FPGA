import struct
import numpy as np
def float_to_bin(num):
    bits, = struct.unpack('!I', struct.pack('!f', num))
    return "{:032b}".format(bits)

#Main
path="C:/Users/ahmed/Desktop/Logic Design 2 Project/Parameters With No Seperators/"
filename="filtersconv2d_3"
filereadpath=path+filename+".txt"
filewritepath=path+filename+"_IEEE16.txt"
file=open(filereadpath,"r")
filewrite=open(filewritepath,"w")
if (file.mode=="r"):
    count = 0
    content=file.readlines()
    for idx,num in enumerate(content):
        num.replace('\n','')
        IEEE = bin(np.float16(num).view('H'))[2:].zfill(16)
        dec = int(IEEE,2)
        stringo = hex(dec)
        #IEEE=int(IEEE,2)
        #IEEE=hex(IEEE)
        string=stringo.split('0x')
        if (string[1] == "0"):
            filewrite.write("0000")
        elif (len(string[1]) == 3):
            filewrite.write("0" + string[1])
        elif (len(string[1]) == 2):
            filewrite.write("00" + string[1])
        else:
            filewrite.write(string[1])
        filewrite.write("\n")
file.close()
filewrite.close()
