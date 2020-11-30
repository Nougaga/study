import heapq

if __name__ == "__main__":
    D = list({0: 4, 1: 3, 5: 2, 8: 1, 4: 0, 3: 4}.items()) + list({2: 3, 3: 2, 7: 1, 5: 0}.items())

    heapq.heapify(D)
    for i in range(len(D)):
        print(heapq.heappop(D))
