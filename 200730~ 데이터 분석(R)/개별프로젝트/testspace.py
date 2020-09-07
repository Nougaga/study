import sys


string = sys.stdin.readline().rstrip()
if len(string)==0:
    print(0)
else:
    if string[0]==" ": 
        string = string[1:len(string)]
    print(string.count(" ")+1)

print(sys.getsizeof(string))