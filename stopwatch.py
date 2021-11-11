from time import time

def stopwatch(func):
    def wrapper():
        start = time()
        func()
        end = time()
        print(f"Time: {end - start:.4f}s")
    return wrapper

@stopwatch
def repeat(func):
    for i in range(count):
        func()

def solution():
    return -1

if __name__ == "__main__":
    pass