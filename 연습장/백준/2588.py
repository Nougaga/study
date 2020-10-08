A = int(input())
B = int(input())

temp = B % 10
print(A * temp)

temp = B % 100 // 10
print(A * temp)

temp = B // 100
print(A * temp)

print(A*B)