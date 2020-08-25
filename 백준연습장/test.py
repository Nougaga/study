import sys
# a,b = map(int,sys.stdin.readline().rstrip().split())
# N = int(sys.stdin.readline())
# A = list(map(int,sys.stdin.readline().rstrip().split()))

string = sys.stdin.readline().rstrip()

res = 0
for i in range(len(string)):
    temp = (ord(string[i])-56)
    if temp >= 27:
        temp -= 1
    if temp >= 33:
        temp -= 1
    temp //= 3
    res += temp
print(res)