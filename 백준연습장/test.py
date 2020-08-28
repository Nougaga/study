import sys


N = int(sys.stdin.readline())
res = N

for i in range(N):
    word = list(sys.stdin.readline().rstrip())

    j = 0
    while(True):
        if j >= len(word)-1:
            break

        if word[j] == word[j+1]:
            del word[j+1]
        else:
            j += 1

    length = len(word)
    j = 0
    while(True):
        if j >= length:
            break
        k = j+1
        while(True):
            if k >= length:
                break
            if word[j] == word[k]:
                res -= 1
                j = length
                break
            k += 1
        j += 1

print(res)
