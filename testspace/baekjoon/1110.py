import sys


N = int(sys.stdin.readline().rstrip())
n = N
cycle = 0
last_right = 0
while True:
    last_right = n % 10
    if n < 10:
        n *= 10
    n = n//10 + n % 10
    n %= 10
    n += last_right*10
    cycle += 1
    if n == N:
        break

print(cycle)
