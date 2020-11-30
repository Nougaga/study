from time import time
start = time()  # 시작 시간 저장

LENGTH = 1000000

if __name__ == "__main__":
    
    array = [0 for n in range(LENGTH)]

    for i in range(LENGTH):
        temp = array.pop()



    


    end = time()
    print("time: {}ms".format((end - start)*1000))
