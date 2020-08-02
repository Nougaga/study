import sys
# 머리가 나쁘면 몸이 고생이라고 했다
# print('*'*i)
N = int(sys.stdin.readline())
i = 1

while True:
    if i == N:
        break
    ii = i
    while True:
        print('*', end='')
        ii -= 1
        if ii == 0:
            break
    print('')
    i += 1

while True:
    ii = i
    while True:
        print('*', end='')
        ii -= 1
        if ii == 0:
            break
    i -= 1
    if i == 0:
        break
    print('')
