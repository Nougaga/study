def solution(n,ladder):
    # n-1개 (n은 남은 자리 찾아가면 됨)
    answer = [-1 for n in range(n)]
    h_ladder = len(ladder)
    w_ladder = n - 1
    for num in range(n):
        pos = num
        for h in range(h_ladder):
            current_ladder = ladder[h]
            # 왼쪽 탐색
            guide = pos-1
            if guide >= 0 and current_ladder[guide]:
                pos -= 1
                continue

            # 오른쪽 탐색
            guide += 1
            if guide < w_ladder and current_ladder[guide]:
                pos += 1

        answer[pos] = num

    answer = list(map(lambda x: x+1, answer))
    return answer

if __name__=="__main__" :
    # elem = [0 for n in range(99)]

    # MATRIX = []
    # for j in range(1000):
    #     MATRIX.append(elem.copy())

    # MATRIX[1][18]=1
    # MATRIX[1][16]=1
    # MATRIX[2][17]=1
    # print(solution(100,MATRIX))
    print(solution(5,[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],[0,0,0,1],[0,0,1,0],[0,0,1,0],[1,0,0,0]]))
