import sys


N = int(sys.stdin.readline())
i = 0

j = 2*N - 1
while True:
    if i >= N:
        break
    print(' '*i, '*'*j, sep='', end='')
    i += 1
    j -= 2
    print('')

i -= 2
j += 4
while True:
    if i <= -1:
        break
    print(' '*i, '*'*j, sep='', end='')
    i -= 1
    j += 2
    print('')