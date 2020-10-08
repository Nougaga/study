import sys


N = int(sys.stdin.readline())
if N==1: print("*")
else:
    n1 = (N +1) //2
    n2 = N //2

    for i in range(N):
        print("* "*n1)
        print(" *"*n2)
