class Node:
    def __init__(self):
        self.value = ""
        self.child = []

    def get_key(self):
        return self.value

    def get_child(self):
        return self.child

    def add_child(self, string):
        newNode = Node()
        newNode.value = string
        self.child.append(newNode)


class Trie:
    def __init__(self):
        self.root = Node()

    def add_word(self, string, node=None):
        if node == None:
            node = self.root

        depth = len(node.value)
        lenString = len(string)
        if depth == lenString:
            print("'{}' is included.".format(string))
            return 0

        lenChild = len(node.child)
        ptChild = 0
        tempString = string[:depth+1]
        while ptChild < lenChild:
            is_found = node.child[ptChild].value == tempString
            if is_found:
                break
            ptChild += 1
        if ptChild >= lenChild:
            node.add_child(tempString)
        self.add_word(string, node=node.child[ptChild])

    def count_child(self, node=None):
        if node==None:
            node=self.root
        
        if len(node.child) != 0:
            res = len(node.child)
            for i in range(len(node.child)):
                res += self.count_child(node=node.child[i])
        else:
            res = 0

        return res

    def count_leaf(self, node=None):
        if node==None:
            node=self.root
        if len(node.child) == 0:
            if node != self.root:
                return 1
            else: return 0
        else:
            res = 0
            for i in range(len(node.child)):
                res += self.count_leaf(node=node.child[i])
            return res


TrieTree = Trie()
# TrieTree.add_word("word")
# TrieTree.add_word("work")
# TrieTree.add_word("word")
# TrieTree.add_word("word")
# TrieTree.add_word("work")
# TrieTree.add_word("wore")
print(TrieTree.count_child())
print(TrieTree.count_leaf())




