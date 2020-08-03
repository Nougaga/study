from django.test import TestCase


N = 50
for i in range(N):
    N -= 5
    print(i, N, end=" ")
