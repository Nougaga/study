import sys
# a,b = map(int,sys.stdin.readline().rstrip().split())
# N = int(sys.stdin.readline())
# A = list(map(int,sys.stdin.readline().rstrip().split()))

C = int(sys.stdin.readline())
res = []

for i in range(C):
    A = list(map(int, sys.stdin.readline().rstrip().split()))
    res.append(0)
    n = A[0]
    avg = (sum(A)-n)/n

    j = 1
    while(j <= n):
        if (A[j] > avg):
            res[i] += 1
        j += 1 

    res[i] = round(res[i]/n*100,3)
    

for i in range(C):
    print("%.3f" % res[i], "%", sep="")
