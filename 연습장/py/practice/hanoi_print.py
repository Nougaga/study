import sys

n = int(sys.stdin.readline())
H = list()
for i in range(1,n+1):
    H.append([i, 0, 0])

while True:
    print("-"*6)
    for i in range(n):
        for j in range(3):
            temp = H[i][j]
            if temp:
                print(temp, end=" ")
            else:
                print(" ", end=" ")
        print()
    print("-"*n*2)
    try:
        f, t = map(int, sys.stdin.readline().split())
    except ValueError:
        print("유효하지 않은 입력")
        continue
    if f <= 0 or t <= 0:
        print("종료")
        break
    elif f > 3 or t > 3:
        print(f"Error: {n} 이하로 입력")
        continue
    f -= 1
    t -= 1
    s = 0
    for i in range(n):
        temp = H[i][f]
        if temp:
            s = temp
            H[i][f] = 0
            break
    if not s:
        print("Error: 비어 있음")
        continue
    if H[0][t]:
        print("Error: 꽉 찼음")
        continue
    for i in range(n-1):
        temp = H[i+1][t]
        if not temp:
            continue
        elif temp < s:
            print("Error: 쌓을 수 없음")
            break
        else:
            H[i][t] = s
            s = 0
            break
    if s:
        H[n-1][t] = s
