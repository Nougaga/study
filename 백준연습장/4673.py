def d(n:int, L:list, l:int):
    x1 = n%10
    x5 = n//10
    x2 = x5%10
    x5 = x5//10
    x3 = x5%10
    x5 = x5//10
    x4 = x5%10
    x5 = x5//10
    notSelfNum = n +x1 +x2 +x3 +x4 +x5
    if notSelfNum <= l:
        if L[notSelfNum] != -1:
            L[notSelfNum] = -1
            d(notSelfNum, L, l)

LIST_LENGTH = 10000
A = list(range(LIST_LENGTH+1))

i = 1
while (i<=LIST_LENGTH):
    d(i, A, LIST_LENGTH)
    i += 1

i = 1
while (i<=LIST_LENGTH):
    res = A[i]
    if res != -1:
        print(A[i])
    i += 1