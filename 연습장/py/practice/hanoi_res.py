import sys


def hanoi(N, x, y, capture=False):
    temp = x+y
    if x == y or temp < 3 or temp > 5:
        raise Exception("올바르지 않은 입력입니다.")
    z = 6 - temp
    K = 0
    if N <= 1:
        if capture:
            print(x, y)
        return 1

    else:
        K += hanoi(N-1, x, z, capture)
        if capture:
            print(x, y)
        K += 1
        K += hanoi(N-1, z, y, capture)
        return K


if __name__ == '__main__':
    N = int(sys.stdin.readline())
    print(hanoi(N, 1, 3))
    hanoi(N, 1, 3, capture=True)
