from heapq import heapify, heappush, heappop

def solution(scoville, K):
    answer = 0
    heapify(scoville)
    while True:
        temp = scoville[0]
        if temp >= K:
            break 
        if len(scoville) <= 1:
            answer = -1
            break
        heappush(scoville, heappop(scoville) + heappop(scoville)*2)
        answer += 1
    return answer

if __name__ == "__main__":
    scoville = [1, 2, 3, 9, 10, 12]
    K = 7

    print(solution(scoville, K))

    