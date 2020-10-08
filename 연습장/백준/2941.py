import sys


string = list(sys.stdin.readline().rstrip())

i = 0
while(True):
    length = len(string)

    if i == length:
        break

    elif i < length-1:
        first = string[i]
        second = string[i+1]
        if second == "=":
            if first == "c" or first == "s" or first == "z":
                del string[i+1]

        elif second == "-":
            if first == "c" or first == "d":
                del string[i+1]

        elif second == "z":
            if i < length-2:
                if first == "d" and string[i+2] == "=":
                    del string[i+1]
                    del string[i+1]

        elif second == "j":
            if first == "l" or first == "n":
                del string[i+1]

    i += 1

print(len(string))
