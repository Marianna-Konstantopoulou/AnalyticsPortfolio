from VRP_Model import *
from SolutionDrawer import *


class Solution:
    def __init__(self):
        self.cost = 0.0
        self.routes = []


class RelocationMove(object):
    def __init__(self):
        self.originRoutePosition = None
        self.targetRoutePosition = None
        self.originNodePosition = None
        self.targetNodePosition = None
        self.costChangeOriginRt = None
        self.costChangeTargetRt = None
        self.moveCost = None

    def Initialize(self):
        self.originRoutePosition = None
        self.targetRoutePosition = None
        self.originNodePosition = None
        self.targetNodePosition = None
        self.costChangeOriginRt = None
        self.costChangeTargetRt = None
        self.moveCost = 10 ** 9

#class SwapMove(object):
#   def __init__(self):
#        self.positionOfFirstRoute = None
#        self.positionOfSecondRoute = None
#        self.positionOfFirstNode = None
#        self.positionOfSecondNode = None
#        self.costChangeFirstRt = None
#        self.costChangeSecondRt = None
#        self.moveCost = None
#    def Initialize(self):
#        self.positionOfFirstRoute = None
#        self.positionOfSecondRoute = None
#        self.positionOfFirstNode = None
#        self.positionOfSecondNode = None
#        self.costChangeFirstRt = None
#        self.costChangeSecondRt = None
#        self.moveCost = 10 ** 9

class CustomerInsertion(object):
    def __init__(self):
        self.customer = None
        self.route = None
        self.cost = 10 ** 9


class CustomerInsertionAllPositions(object):
    def __init__(self):
        self.customer = None
        self.route = None
        self.insertionPosition = None
        self.cost = 10 ** 9

#class TwoOptMove(object):
#    def __init__(self):
#        self.positionOfFirstRoute = None
#        self.positionOfSecondRoute = None
#        self.positionOfFirstNode = None
#        self.positionOfSecondNode = None
#        self.moveCost = None
#    def Initialize(self):
#        self.positionOfFirstRoute = None
#        self.positionOfSecondRoute = None
#        self.positionOfFirstNode = None
#        self.positionOfSecondNode = None
#        self.moveCost = 10 ** 9

class Solver:
    def __init__(self, m):
        self.nodes = m.nodes
        self.gpoints = m.gpoints
        self.depot = m.nodes[0]
        self.distanceMatrix = m.tmatrix
        self.capacity = m.capacity
        self.sol = None
        self.bestSolution = None
        self.searchTrajectory = []
        self.rtCounter = 0
        self.rtInd = -1
        self.iterations = None

    def solve(self):
        self.SetRoutedFlagToFalseForAllgpoints()
        self.MinimumInsertions()
        self.ReportSolution(self.sol)
        self.LocalSearch(0)
        self.ReportSolution(self.sol)

        return self.sol

    def SetRoutedFlagToFalseForAllgpoints(self):
        for i in range(0, len(self.gpoints)):
            self.gpoints[i].isRouted = False

    def MinimumInsertions(self):
        modelIsFeasible = True
        self.sol = Solution()
        insertions = 0
        distFrombase = self.distanceMatrix[0]
        closest26gpoints = sorted(range(1, len(distFrombase)), key=lambda k: distFrombase[k])[:26]
        j = 1
        insPos = 0
        for i in closest26gpoints:
            rt = Route(self.depot, self.capacity)
            self.sol.routes.append(rt)
            randomInsertion = CustomerInsertionAllPositions()
            randomInsertion.customer = self.nodes[i]
            randomInsertion.customer.demand = self.nodes[i].demand
            randomInsertion.route = self.sol.routes[closest26gpoints.index(i)]
            randomInsertion.cost = self.distanceMatrix[0][i]
            randomInsertion.insertionPosition = insPos
            self.ApplyCustomerInsertionAllPositions(randomInsertion)
            insertions += 1
            self.rtCounter = 1

        while insertions < len(self.gpoints):
            bestInsertion = CustomerInsertionAllPositions()
            if self.rtInd == 25:
                self.rtInd = 0
            else:
                self.rtInd += 1

            lastOpenRoute: Route = self.GetLastOpenRoute()

            if lastOpenRoute is not None:
                self.IdentifyBestInsertionAllPositions(bestInsertion, lastOpenRoute)

            if bestInsertion.customer is not None:
                self.ApplyCustomerInsertionAllPositions(bestInsertion)
                insertions += 1

            else:
                # If there is an empty available route
                if lastOpenRoute is not None and len(lastOpenRoute.sequenceOfNodes) == 2:
                    modelIsFeasible = False
                    break
                # If there is no empty available route and no feasible insertion was identified
                else:
                    self.rtCounter += 1

        if modelIsFeasible == False:
            print('FeasibilityIssue')

        self.TestSolution()

    def LocalSearch(self, operator):
        localSearchIterator = 0
        self.bestSolution = self.cloneSolution(self.sol)

        terminationCondition = False

        rm = RelocationMove()

        self.searchTrajectory.append(self.sol.cost)

        while terminationCondition is False:

            self.InitializeOperators(rm, )
            SolDrawer.draw(localSearchIterator, self.sol, self.nodes)

            # Relocations
            if operator == 0:
                self.FindBestRelocationMove(rm)
                if rm.originRoutePosition is not None:
                    if rm.moveCost < 0:
                        self.ApplyRelocationMove(rm)
                    else:
                        self.iterations = localSearchIterator
                        terminationCondition = True
            else:
                print("wrong operator, try again with 0")
	
	    # Swaps
            # elif operator == 1:
            #     self.FindBestSwapMove(sm)
            #     if sm.positionOfFirstRoute is not None:
            #         if sm.moveCost < 0:
            #             self.ApplySwapMove(sm)
            #         else:
            #             terminationCondition = True
            # elif operator == 2:
            #     self.FindBestTwoOptMove(top)
            #     if top.positionOfFirstRoute is not None:
            #         if top.moveCost < 0:
            #             self.ApplyTwoOptMove(top)
            #         else:
            #             terminationCondition = True  
	
            self.TestSolution()

            if self.sol.cost < self.bestSolution.cost:
                self.bestSolution = self.cloneSolution(self.sol)
            self.searchTrajectory.append(self.sol.cost)
            localSearchIterator = localSearchIterator + 1

        SolDrawer.drawTrajectory(self.searchTrajectory)
        self.sol = self.bestSolution
     

    def cloneRoute(self, rt: Route):
        cloned = Route(self.depot, self.capacity)
        cloned.cost = rt.cost
        cloned.load = rt.load
        cloned.sequenceOfNodes = rt.sequenceOfNodes.copy()
        return cloned

    def cloneSolution(self, sol: Solution):
        cloned = Solution()
        for i in range(0, len(sol.routes)):
            rt = sol.routes[i]
            clonedRoute = self.cloneRoute(rt)
            cloned.routes.append(clonedRoute)
        cloned.cost = self.sol.cost
        return cloned

    def FindBestRelocationMove(self, rm):
        for originRouteIndex in range(len(self.sol.routes)):
            rt1 = self.sol.routes[originRouteIndex]
            for targetRouteIndex in range(len(self.sol.routes)):
                rt2 = self.sol.routes[targetRouteIndex]
                for originNodeIndex in range(1, len(rt1.sequenceOfNodes) - 2):
                    for targetNodeIndex in range(0, len(rt2.sequenceOfNodes) - 2):
                        if originRouteIndex == targetRouteIndex and (targetNodeIndex == originNodeIndex or targetNodeIndex == originNodeIndex - 1):
                            continue
                        A = rt1.sequenceOfNodes[originNodeIndex - 1]
                        B = rt1.sequenceOfNodes[originNodeIndex]
                        C = rt1.sequenceOfNodes[originNodeIndex + 1]
                        F = rt2.sequenceOfNodes[targetNodeIndex]
                        G = rt2.sequenceOfNodes[targetNodeIndex + 1]
                        if rt1 != rt2 and rt2.load + B.demand > rt2.capacity:
                            continue
                        costAdded = self.distanceMatrix[A.ID][C.ID] + self.distanceMatrix[F.ID][B.ID] + self.distanceMatrix[B.ID][G.ID]
                        costRemoved = self.distanceMatrix[A.ID][B.ID] + self.distanceMatrix[B.ID][C.ID] + self.distanceMatrix[F.ID][G.ID]
                        originRtCostChange = self.distanceMatrix[A.ID][C.ID] - self.distanceMatrix[A.ID][B.ID] - self.distanceMatrix[B.ID][C.ID]
                        targetRtCostChange = self.distanceMatrix[F.ID][B.ID] + self.distanceMatrix[B.ID][G.ID] - self.distanceMatrix[F.ID][G.ID]
                        moveCost = costAdded - costRemoved
                        if moveCost < rm.moveCost and abs(moveCost) and originRtCostChange + rt1.cost < self.sol.cost and targetRtCostChange + rt2.cost < self.sol.cost:
                            self.StoreBestRelocationMove(originRouteIndex, targetRouteIndex, originNodeIndex, targetNodeIndex, moveCost, originRtCostChange, targetRtCostChange, rm)
    # def FindBestSwapMove(self, sm):
    #         for firstRouteIndex in range(0, len(self.sol.routes)):
    #             rt1:Route = self.sol.routes[firstRouteIndex]
    #             for firstNodeIndex in range (1, len(rt1.sequenceOfNodes) - 1):
    #                 # first swapped node is cdetermined
    #                 for secondRouteIndex in range(firstRouteIndex, len(self.sol.routes)):
    #                     rt2: Route = self.sol.routes[secondRouteIndex]
    #                     startOfSecondNodeIndex = 1
    #                     if rt1 == rt2:
    #                         startOfSecondNodeIndex = firstNodeIndex + 1
    #                     for secondNodeIndex in range (startOfSecondNodeIndex, len(rt2.sequenceOfNodes) - 1):

    #                         a1 = rt1.sequenceOfNodes[firstNodeIndex - 1]
    #                         b1 = rt1.sequenceOfNodes[firstNodeIndex]
    #                         c1 = rt1.sequenceOfNodes[firstNodeIndex + 1]

    #                         a2 = rt2.sequenceOfNodes[secondNodeIndex - 1]
    #                         b2 = rt2.sequenceOfNodes[secondNodeIndex]
    #                         c2 = rt2.sequenceOfNodes[secondNodeIndex + 1]

    #                         moveCost = None
    #                         costChangeFirstRoute = None
    #                         costChangeSecondRoute = None

    #                         if rt1 == rt2:
    #                             if firstNodeIndex == secondNodeIndex - 1:
    #                                 # case of consecutive nodes swap
    #                                 costRemoved = self.distanceMatrix[a1.ID][b1.ID] + self.distanceMatrix[b1.ID][b2.ID] + \
    #                                               self.distanceMatrix[b2.ID][c2.ID]
    #                                 costAdded = self.distanceMatrix[a1.ID][b2.ID] + self.distanceMatrix[b2.ID][b1.ID] + \
    #                                             self.distanceMatrix[b1.ID][c2.ID]
    #                                 moveCost = costAdded - costRemoved
    #                             else:

    #                                 costRemoved1 = self.distanceMatrix[a1.ID][b1.ID] + self.distanceMatrix[b1.ID][c1.ID]
    #                                 costAdded1 = self.distanceMatrix[a1.ID][b2.ID] + self.distanceMatrix[b2.ID][c1.ID]
    #                                 costRemoved2 = self.distanceMatrix[a2.ID][b2.ID] + self.distanceMatrix[b2.ID][c2.ID]
    #                                 costAdded2 = self.distanceMatrix[a2.ID][b1.ID] + self.distanceMatrix[b1.ID][c2.ID]
    #                                 moveCost = costAdded1 + costAdded2 - (costRemoved1 + costRemoved2)
    #                         else:
    #                             if rt1.load - b1.demand + b2.demand > self.capacity:
    #                                 continue
    #                             if rt2.load - b2.demand + b1.demand > self.capacity:
    #                                 continue

    #                             costRemoved1 = self.distanceMatrix[a1.ID][b1.ID] + self.distanceMatrix[b1.ID][c1.ID]
    #                             costAdded1 = self.distanceMatrix[a1.ID][b2.ID] + self.distanceMatrix[b2.ID][c1.ID]
    #                             costRemoved2 = self.distanceMatrix[a2.ID][b2.ID] + self.distanceMatrix[b2.ID][c2.ID]
    #                             costAdded2 = self.distanceMatrix[a2.ID][b1.ID] + self.distanceMatrix[b1.ID][c2.ID]

    #                             costChangeFirstRoute = costAdded1 - costRemoved1
    #                             costChangeSecondRoute = costAdded2 - costRemoved2

    #                             moveCost = costAdded1 + costAdded2 - (costRemoved1 + costRemoved2)

    #                         if moveCost < sm.moveCost:
    #                             self.StoreBestSwapMove(firstRouteIndex, secondRouteIndex, firstNodeIndex, secondNodeIndex,
    #                                                    moveCost, costChangeFirstRoute, costChangeSecondRoute, sm)

    def ApplyRelocationMove(self, rm: RelocationMove):
        originRt = self.sol.routes[rm.originRoutePosition]
        targetRt = self.sol.routes[rm.targetRoutePosition]
        B = originRt.sequenceOfNodes[rm.originNodePosition]
        if originRt == targetRt:
            del originRt.sequenceOfNodes[rm.originNodePosition]
            targetRt.sequenceOfNodes.insert(rm.targetNodePosition + (rm.originNodePosition > rm.targetNodePosition), B)
            originRt.cost += rm.moveCost
        else:
            del originRt.sequenceOfNodes[rm.originNodePosition]
            targetRt.sequenceOfNodes.insert(rm.targetNodePosition + 1, B)
            originRt.cost += rm.costChangeOriginRt
            targetRt.cost += rm.costChangeTargetRt
            originRt.load -= B.demand
            targetRt.load += B.demand
        self.sol.cost = self.CalculateTotalCost(self.sol)

    # def ApplySwapMove(self, sm):
    #    oldCost = self.CalculateTotalCost(self.sol)
    #    rt1 = self.sol.routes[sm.positionOfFirstRoute]
    #    rt2 = self.sol.routes[sm.positionOfSecondRoute]
    #    b1 = rt1.sequenceOfNodes[sm.positionOfFirstNode]
    #    b2 = rt2.sequenceOfNodes[sm.positionOfSecondNode]
    #    rt1.sequenceOfNodes[sm.positionOfFirstNode] = b2
    #    rt2.sequenceOfNodes[sm.positionOfSecondNode] = b1

    #    if rt1 == rt2:
    #        rt1.cost += sm.moveCost
    #    else:
    #        rt1.cost += sm.costChangeFirstRt
    #        rt2.cost += sm.costChangeSecondRt
    #        rt1.load = rt1.load - b1.demand + b2.demand
    #        rt2.load = rt2.load + b1.demand - b2.demand

    #    self.sol.cost += sm.moveCost

    #    newCost = self.CalculateTotalCost(self.sol)
    #    # debuggingOnly
    #    if abs((newCost - oldCost) - sm.moveCost) > 0.0001:
    #        print('Cost Issue')

    def ReportSolution(self, sol):

        print('Objective:')
        print(str(self.sol.cost)+' hr')

        print('Routes:')
        k = 0
        for i in range(0, len(sol.routes)):
            rt = sol.routes[i]
            if len(rt.sequenceOfNodes)-2 > 0:
                k = k+1
        print(k)
        print('Routes Summary:')
        for i in range(0, len(sol.routes)):
            rt = sol.routes[i]
            if len(rt.sequenceOfNodes) - 2 > 0:
                for j in range(0, len(rt.sequenceOfNodes)-1):
                    print(rt.sequenceOfNodes[j].ID, end=' ')
                print(' ')
                #print(rt.cost)
            #print(self.sol.cost)

        if self.iterations is not None:
            iterationStr = "The objective function was trapped in the optimal cost of {} hours after {} iterations." \
                .format(str(self.CalculateTotalCost(self.sol)), str(self.iterations))
            print(iterationStr)

    def GetLastOpenRoute(self):
        if self.rtCounter == 0:
            return None
        else:
            return self.sol.routes[self.rtInd]

    def InitializeOperators(self, rm):
        rm.Initialize()

    # def IdentifyBestInsertion(self, bestInsertion, rt):
    #     for i in range(0, len(self.customers)):
    #         candidateCust:Node = self.customers[i]
    #         if candidateCust.isRouted is False:
    #             if rt.load + candidateCust.demand <= rt.capacity:
    #                 lastNodePresentInTheRoute = rt.sequenceOfNodes[-2]
    #                 trialCost = self.distanceMatrix[lastNodePresentInTheRoute.ID][candidateCust.ID]
    #                 if trialCost < bestInsertion.cost:
    #                     bestInsertion.customer = candidateCust
    #                     bestInsertion.route = rt
    #                     bestInsertion.cost = trialCost

    # def ApplyCustomerInsertion(self, insertion):
    #     insCustomer = insertion.customer
    #     rt = insertion.route
    #     #before the second depot occurrence
    #     insIndex = len(rt.sequenceOfNodes) - 1
    #     rt.sequenceOfNodes.insert(insIndex, insCustomer)

    #     beforeInserted = rt.sequenceOfNodes[-3]

    #     costAdded = self.distanceMatrix[beforeInserted.ID][insCustomer.ID] + self.distanceMatrix[insCustomer.ID][self.depot.ID]
    #     costRemoved = self.distanceMatrix[beforeInserted.ID][self.depot.ID]

    #     rt.cost += costAdded - costRemoved
    #     self.sol.cost += costAdded - costRemoved

    #     rt.load += insCustomer.demand

    #     insCustomer.isRouted = True

    def StoreBestRelocationMove(self, originRouteIndex, targetRouteIndex, originNodeIndex,
                                targetNodeIndex, moveCost,
                                originRtCostChange, targetRtCostChange, rm: RelocationMove):
        rm.originRoutePosition = originRouteIndex
        rm.originNodePosition = originNodeIndex
        rm.targetRoutePosition = targetRouteIndex
        rm.targetNodePosition = targetNodeIndex
        rm.costChangeOriginRt = originRtCostChange
        rm.costChangeTargetRt = targetRtCostChange
        rm.moveCost = moveCost

    # def StoreBestSwapMove(self, firstRouteIndex, secondRouteIndex, firstNodeIndex, secondNodeIndex, moveCost, costChangeFirstRoute, costChangeSecondRoute, sm):
    #     sm.positionOfFirstRoute = firstRouteIndex
    #     sm.positionOfSecondRoute = secondRouteIndex
    #     sm.positionOfFirstNode = firstNodeIndex
    #     sm.positionOfSecondNode = secondNodeIndex
    #     sm.costChangeFirstRt = costChangeFirstRoute
    #     sm.costChangeSecondRt = costChangeSecondRoute
    #     sm.moveCost = moveCost

    def CalculateTotalCost(self, sol):
        c = []
        for i in range(0, len(sol.routes)):
            rt = sol.routes[i]
            r = []
            for j in range(0, len(rt.sequenceOfNodes) - 1):
                a = rt.sequenceOfNodes[j]
                b = rt.sequenceOfNodes[j + 1]
                r.append(self.distanceMatrix[a.ID][b.ID])
            c.append(sum(r))
        cst = max(c)
        return cst
    #    def InitializeOperators(self, rm, sm, top):
    #       rm.Initialize()
    #   sm.Initialize()
    #   top.Initialize()

    # def FindBestTwoOptMove(self, top):
    #     for rtInd1 in range(0, len(self.sol.routes)):
    #         rt1:Route = self.sol.routes[rtInd1]
    #         for nodeInd1 in range(0, len(rt1.sequenceOfNodes) - 1):
    #             # first node is determined
    #             A = rt1.sequenceOfNodes[nodeInd1]
    #             B = rt1.sequenceOfNodes[nodeInd1 + 1]

    #             for rtInd2 in range(rtInd1, len(self.sol.routes)):

    #                 rt2: Route = self.sol.routes[rtInd2]
    #                 start2 = 0 #inter-route move
    #                 if rt1 == rt2:
    #                     start2 = nodeInd1 + 2 #intra-route move

    #                 for nodeInd2 in range(start2, len(rt2.sequenceOfNodes) - 1):

    #                     K = rt2.sequenceOfNodes[nodeInd2]
    #                     L = rt2.sequenceOfNodes[nodeInd2 + 1]

    #                     if rt1 == rt2:
    #                         if nodeInd1 == 0 and nodeInd2 == len(rt1.sequenceOfNodes) - 2:
    #                             continue
    #                         costAdded = self.distanceMatrix[A.ID][K.ID] + self.distanceMatrix[B.ID][L.ID]
    #                         costRemoved = self.distanceMatrix[A.ID][B.ID] + self.distanceMatrix[K.ID][L.ID]
    #                         moveCost = costAdded - costRemoved
    #                     else:
    #                         if nodeInd1 == 0 and nodeInd2 == 0:
    #                             continue
    #                         if nodeInd1 == len(rt1.sequenceOfNodes) - 2 and  nodeInd2 == len(rt2.sequenceOfNodes) - 2:
    #                             continue

    #                         if self.CapacityIsViolated(rt1, nodeInd1, rt2, nodeInd2):
    #                             continue
    #                         costAdded = self.distanceMatrix[A.ID][L.ID] + self.distanceMatrix[B.ID][K.ID]
    #                         costRemoved = self.distanceMatrix[A.ID][B.ID] + self.distanceMatrix[K.ID][L.ID]
    #                         moveCost = costAdded - costRemoved
    #                     if moveCost < top.moveCost:
    #                         self.StoreBestTwoOptMove(rtInd1, rtInd2, nodeInd1, nodeInd2, moveCost, top)


    # def CapacityIsViolated(self, rt1, nodeInd1, rt2, nodeInd2):

    #     rt1FirstSegmentLoad = 0
    #     for i in range(0, nodeInd1 + 1):
    #         n = rt1.sequenceOfNodes[i]
    #         rt1FirstSegmentLoad += n.demand
    #     rt1SecondSegmentLoad = rt1.load - rt1FirstSegmentLoad

    #     rt2FirstSegmentLoad = 0
    #     for i in range(0, nodeInd2 + 1):
    #         n = rt2.sequenceOfNodes[i]
    #         rt2FirstSegmentLoad += n.demand
    #     rt2SecondSegmentLoad = rt2.load - rt2FirstSegmentLoad

    #     if (rt1FirstSegmentLoad + rt2SecondSegmentLoad > rt1.capacity):
    #         return True
    #     if (rt2FirstSegmentLoad + rt1SecondSegmentLoad > rt2.capacity):
    #         return True

    #     return False

    # def StoreBestTwoOptMove(self, rtInd1, rtInd2, nodeInd1, nodeInd2, moveCost, top):
    #     top.positionOfFirstRoute = rtInd1
    #     top.positionOfSecondRoute = rtInd2
    #     top.positionOfFirstNode = nodeInd1
    #     top.positionOfSecondNode = nodeInd2
    #     top.moveCost = moveCost

    # def ApplyTwoOptMove(self, top):
    #     rt1:Route = self.sol.routes[top.positionOfFirstRoute]
    #     rt2:Route = self.sol.routes[top.positionOfSecondRoute]

    #     if rt1 == rt2:
    #         # reverses the nodes in the segment [positionOfFirstNode + 1,  top.positionOfSecondNode]
    #         reversedSegment = reversed(rt1.sequenceOfNodes[top.positionOfFirstNode + 1: top.positionOfSecondNode + 1])
    #         #lst = list(reversedSegment)
    #         #lst2 = list(reversedSegment)
    #         rt1.sequenceOfNodes[top.positionOfFirstNode + 1 : top.positionOfSecondNode + 1] = reversedSegment

    #         #reversedSegmentList = list(reversed(rt1.sequenceOfNodes[top.positionOfFirstNode + 1: top.positionOfSecondNode + 1]))
    #         #rt1.sequenceOfNodes[top.positionOfFirstNode + 1: top.positionOfSecondNode + 1] = reversedSegmentList

    #         rt1.cost += top.moveCost

    #     else:
    #         #slice with the nodes from position top.positionOfFirstNode + 1 onwards
    #         relocatedSegmentOfRt1 = rt1.sequenceOfNodes[top.positionOfFirstNode + 1 :]

    #         #slice with the nodes from position top.positionOfFirstNode + 1 onwards
    #         relocatedSegmentOfRt2 = rt2.sequenceOfNodes[top.positionOfSecondNode + 1 :]

    #         del rt1.sequenceOfNodes[top.positionOfFirstNode + 1 :]
    #         del rt2.sequenceOfNodes[top.positionOfSecondNode + 1 :]

    #         rt1.sequenceOfNodes.extend(relocatedSegmentOfRt2)
    #         rt2.sequenceOfNodes.extend(relocatedSegmentOfRt1)

    #         self.UpdateRouteCostAndLoad(rt1)
    #         self.UpdateRouteCostAndLoad(rt2)

    #     self.sol.cost += top.moveCost

    # def UpdateRouteCostAndLoad(self, rt: Route):
    #     tc = 0
    #     tl = 0
    #     for i in range(0, len(rt.sequenceOfNodes) - 1):
    #         A = rt.sequenceOfNodes[i]
    #         B = rt.sequenceOfNodes[i+1]
    #         tc += self.distanceMatrix[A.ID][B.ID]
    #         tl += A.demand
    #     rt.load = tl
    #     rt.cost = tc
        
    def TestSolution(self):
        totalSolCost = 0
        for r in range(0, len(self.sol.routes)):
            rt: Route = self.sol.routes[r]
            rtCost = 0
            rtLoad = 0
            for n in range(0, len(rt.sequenceOfNodes) - 1):
                A = rt.sequenceOfNodes[n]
                B = rt.sequenceOfNodes[n + 1]
                rtCost += self.distanceMatrix[A.ID][B.ID]
                rtLoad += A.demand
            if abs(rtCost - rt.cost) > 0.0001:
                print('Route Cost problem: ' + str(abs(rtCost - rt.cost)))
            if rtLoad != rt.load:
                print('Route Load problem')

            totalSolCost = max(totalSolCost, rt.cost)

        if abs(totalSolCost - self.sol.cost) > 0.0001:
            print('Solution Cost problem')

    def IdentifyBestInsertionAllPositions(self, bestInsertion, rt):
        for i in range(len(self.gpoints)):
            candidateCust = self.gpoints[i]
            if not candidateCust.isRouted:
                if rt.load + candidateCust.demand <= rt.capacity:
                    for j in range(len(rt.sequenceOfNodes)-1):
                        A = rt.sequenceOfNodes[j]
                        B = rt.sequenceOfNodes[j+1]
                        costAdded = self.distanceMatrix[A.ID][candidateCust.ID] + self.distanceMatrix[candidateCust.ID][B.ID]
                        costRemoved = self.distanceMatrix[A.ID][B.ID]
                        trialCost = costAdded - costRemoved
                        if trialCost < bestInsertion.cost:
                            bestInsertion.customer = candidateCust
                            bestInsertion.route = rt
                            bestInsertion.cost = trialCost
                            bestInsertion.insertionPosition = j


    def ApplyCustomerInsertionAllPositions(self, insertion):
        insCustomer = insertion.customer
        rt = insertion.route
        # before the second depot occurrence
        insIndex = insertion.insertionPosition
        rt.sequenceOfNodes.insert(insIndex + 1, insCustomer)
        rt.cost += insertion.cost
        self.sol.cost = max(self.sol.cost, rt.cost)
        rt.load += insCustomer.demand
        insCustomer.isRouted = True