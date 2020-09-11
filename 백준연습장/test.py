class Node:
    def __init__(self):
        self.data=None
        self.child=list()

    def setData(self,data:str):
        self.data=data

    def getData(self):
        return self.data

    def addChild(self,child:Node):
        self.child.append(child)
    

A = Node()
B = A

print(id(A)==id(B))