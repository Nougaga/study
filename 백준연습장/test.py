import sys
# a,b = map(int,sys.stdin.readline().rstrip().split())
# N = int(sys.stdin.readline())
# A = list(map(int,sys.stdin.readline().rstrip().split()))


string = sys.stdin.readline().rstrip()

for i in range(len(string)):
    temp = ord(string[i])
    if temp <= 90:
        string[i] = chr(temp + 32)

ca = list()
for i in range(26):
    ca.append(string.count(chr(i+97)))

res = -1
flag = False
for i in range(26):
    if (res<ca[i]):
        res = chr(i+97)
        flag = False
    elif (res==ca[i]):
        flag = True

if (flag):
    print("?")
else:
    print(res)

