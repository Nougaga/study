import sys


A = []
B = []
while True:
    a,b = map(int,sys.stdin.readline().rstrip().split())
    if (a==0 and b==0):
        break
    A.append(a)
    B.append(b)

i = 0
length = len(A)
while True:
    print(A[i]+B[i])
    

