import struct
def float_to_bin(num):
    bits, = struct.unpack('!I', struct.pack('!f', num))
    return "{:032b}".format(bits)

#Main
path="E:\\College\\Senior 1 - 2\\Logic 2\\Labs Code\\ANN\\ANN\\Weight Files\\"
filename="weights3"
filereadpath=path+filename+".txt"
filewritepath=path+filename+"_IEEE.txt"
file=open(filereadpath,"r")
filewrite=open(filewritepath,"w")
count=0
if (file.mode=="r"):
    content=file.readlines()
    for idx,num in enumerate(content):
        num.replace('\n','')
        dec=float(num)
        IEEE=float_to_bin(dec)
        string =str(IEEE)
        if(string[31:32]=='0'):
            count+=1
        IEEE=IEEE[0:31]
        IEEE=int(IEEE,2)
        IEEE=hex(IEEE)
        string=IEEE.split('0x')
        filewrite.write(string[1])
        filewrite.write('\n')
print((count/len(content) *100),"%")
file.close()
filewrite.close()     