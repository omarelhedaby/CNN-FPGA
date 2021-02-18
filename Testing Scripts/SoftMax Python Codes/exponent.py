from math import exp,factorial

def taylor(num,iter):
    sum=1
    for i in range(1,iter+1):
        sum=sum+(num**i/factorial(i))
    return sum


x=float(input("Enter num: "))
real=exp(x)
aprox=1+x+(x**2/2)+(x**3/6)+(x**4/24)+(x**5/120)+(x**6/720)
tay=taylor(x,6)



print("real is {} and approx is {} and func is {} ".format(real,aprox,tay))
