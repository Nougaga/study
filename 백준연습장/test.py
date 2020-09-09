def rot_key(key):
    res = list()
    M = len(key)
    for i in range(M):
        res.append(list())
        for j in range(M):
            res[i].append(key[j][M-1-i])
    return res

key = [[0, 0, 0], [1, 0, 0], [0, 1, 1]]
rot_key(key)