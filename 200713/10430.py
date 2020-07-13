# 5 8 4
A,B,C = map(int,input().split())
r1 = (A+B)%C            # 13%4 = 1
r2 = ((A%C)+(B%C))%C    # (5+0)%4 = 1
r3 = (A*B)%C            # 40%4 = 0
r4 = ((A%C)*(B%C))%C    # (1*0)%4 = 0

print(r1)
print(r2)
print(r3)
print(r4)