import random
import math

class Model:
    def __init__(self):
        self.nodes, self.gpoints, self.tmatrix, self.distmatrix = [], [], [], []
        self.capacity = -1

    def BuildModel(self):
        random.seed(1)
        self.nodes.append(Node(0, 50, 50, 0, 0))
        self.capacity = 3000
        totalgpoints = 200
        for i in range(totalgpoints):
            x, y = random.randint(0, 100), random.randint(0, 100)
            dem = 100 * (1 + random.randint(1, 4))
            unloading_time = 0.25
            point = Node(i + 1, x, y, dem, unloading_time)
            self.nodes.append(point)
            self.gpoints.append(point)

        rows = len(self.nodes)
        self.tmatrix = [[0.0 for _ in range(rows)] for _ in range(rows)]
        self.distmatrix = [[0.0 for _ in range(rows)] for _ in range(rows)]

        for i in range(len(self.nodes)):
            for j in range(len(self.nodes)):
                a, b = self.nodes[i], self.nodes[j]
                dist = math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2))
                time = dist / 40 + unloading_time
                self.distmatrix[i][j] = dist
                self.tmatrix[i][j] = time if j != 0 else 0

class Node:
    def __init__(self, idd, xx, yy, dem, unloading_time):
        self.unloading_time = unloading_time
        self.x, self.y, self.ID, self.demand, self.isRouted = xx, yy, idd, dem, False

class Route:
    def __init__(self, dp, cap):
        self.sequenceOfNodes, self.cost, self.capacity, self.load = [dp, dp], 0, cap, 0