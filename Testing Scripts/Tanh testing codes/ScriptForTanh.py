import numpy as np
import math
import struct


def float_to_bin(num):
    (bits,) = struct.unpack("!I", struct.pack("!f", num))
    return "{:032b}".format(bits)


IEEinput = []
InputNumbers = [
    0.6,
    0.5,
    3.2,
    1.4,
    2,
    1,
    0,
    0.5,
    -0.4,
    -0.5,
    -0.57,
    0.57,
    0.3,
    0.2,
    0.112,
    0.2,
    -0.2,
    -0.5,
    -0.9,
    -0.567,
    -0.43,
    0.5,
    0.7,
    0.86543,
    0.4345,
]

for i in range(0, len(InputNumbers)):
    IEEinput.append(float_to_bin(InputNumbers[i]))

tanhOutput = np.tanh(InputNumbers)
tanhOutputIEEE = []
for i in range(0, len(InputNumbers)):
    tanhOutputIEEE.append(float_to_bin(tanhOutput[i]))

print("List of Numbers as inputs:")
print(InputNumbers)
print("List of Numbers as inputs IEEE:")
print(IEEinput)
print("output  Are ")
print(tanhOutput)
print("output Are IEEE")
print(tanhOutputIEEE)
