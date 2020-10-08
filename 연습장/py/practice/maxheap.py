'''
제대로 구현하고 싶으면 heapq 참고
'''

class MaxHeap():
    def __init__(self, arr):
        self.list = [-1]
        # TODO: 비효율적임. len(arr)//2회로 줄일 수 있음
        for i in range(len(arr)):
            self.insert(arr[i])

    def heapify(self, loc, upper=True):
        location = loc
        if upper:
            parent = location // 2
            if parent > 0 and self.list[parent] < self.list[location]:
                temp = self.list[parent]
                self.list[parent] = self.list[location]
                self.list[location] = temp
                self.heapify(parent)
        else:
            child = location*2 + 1
            length = self.get_length()

            flag = 1
            if child >= length:
                child -= 1
                if child >= length:
                    flag = 0
            else:
                if self.list[child] < self.list[child-1]:
                    child -= 1

            if flag and self.list[location] < self.list[child]:
                temp = self.list[child]
                self.list[child] = self.list[location]
                self.list[location] = temp
                self.heapify(child, upper=False)

    def insert(self, el):
        loc = self.get_length()
        self.list.append(el)
        self.heapify(loc)

    def delete(self):
        length = self.get_length()
        if length > 1:
            res = self.list[1]
            if length > 2:
                self.list[1] = self.list.pop()
                self.heapify(1, upper=False)
            else:
                self.list.pop()
            return res
        else:
            print("삭제할 노드가 없습니다.")
            return -1

    def get_length(self):
        return len(self.list)

    def get_list(self):
        res = self.list.copy()
        res.pop(0)
        return res

    def get_sorted_list(self):
        res = []
        copy = self.list.copy()
        for i in range(self.get_length()-1):
            res.append(self.delete())
        self.list = copy
        return res


if __name__ == '__main__':
    maxHeap = MaxHeap([4, 1, 3, 2, 16, 9, 10, 14, 8, 7])
    print(maxHeap.get_sorted_list())
    print(maxHeap.get_list())
