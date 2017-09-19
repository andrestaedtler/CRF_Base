//
//  MAPPredictionCRF.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation

//this class finds the best labeling given observation -> exponential run time
// for big graphes -> cap the borderlist to a certain amount of nodes
class MAPPredictionCRF<T> {
    
    var inner, outer, border: [CRFNode<T>]!
    var currentLabelings, nextLabelings: [CRFLabeling<T>]!
    
    var outsideEdges: [CRFNode<T> : [CRFEdge<T>]]!
    var numberStates: Int!
    //var debug = false
    
    func calcMAP(queue: [CRFNode<T>], numberStates: Int) -> CRFLabeling<T> {
        outsideEdges = [:]
        for node in queue{
            outsideEdges[node] = [CRFEdge<T>]()
        }
        
        outer = [CRFNode<T>](queue)
        inner = []
        border = []
        
        currentLabelings = []
        nextLabelings = []
        
        self.numberStates = numberStates
        
        for _ in 0..<queue.count{
            
            let node = outer[0]
            outer.remove(at: 0)
            border.append(node)
            updateOutsideEdges(node)
            updateBorderToInner()
            //print("bordersize: \(border.count)")
            createLabeling()
            
            if (!border.contains(node)){
                calcLabelingScoreNodeNotInBorder(node)
            } else {
                calcLabelingScore(node)
            }
            currentLabelings = [CRFLabeling<T>](nextLabelings)
            nextLabelings.removeAll()
            
        }
        
        //get final maximizing labeling
        var max = Double(Int.min)
        var maxLabeling =  CRFLabeling<T>()
        for labeling in currentLabelings{
            if (labeling.score > max){
                max = labeling.score
                maxLabeling = labeling
            }
        }
        return maxLabeling
        
    }
    
    //calc score of new labeling
    func calcLabelingScore(_ borderNode: CRFNode<T>) {
        var possiblePredecessors: [CRFLabeling<T>] = []
        
        for labelNext in nextLabelings {
            
            //find all possible predecessors
            //a label is a predecessor iff all the nodes which are in 
            //both labelings have the same label
            var mapNext = labelNext.labeling
            
            for labelCurr in currentLabelings {
                var isPredecessor = true
                var mapCurr = labelCurr.labeling
                //all nodes in nextlabelings minus the newly added node are
                //also in currentlabelings, these nodes must have the same label
                //in both dictionaries
                for node in mapNext.keys{
                    if node != borderNode {
                        //check if the labels are the same for this node
                        if !(mapCurr[node] == mapNext[node]){
                            isPredecessor = false
                            break
                        }
                    }
                }
                if(isPredecessor){
                    possiblePredecessors.append(labelCurr)
                }
            }
            //calculate the score 
            calcScore(borderNode, possiblePredecessors, mapNext, labelNext)
            possiblePredecessors.removeAll()
            
        }//end of for
    }
    
    func calcLabelingScoreNodeNotInBorder(_ node: CRFNode<T>){
        //fill nextLabeling with each possible labeling for borderNode
        nextLabelings.removeAll()
        for i in 0..<numberStates{
            let labeling = CRFLabeling<T>()
            labeling.addLabeling(node: node, label: i)
            nextLabelings.append(labeling)
        }
        
        var possiblePredecessors: [CRFLabeling<T>] = []
        
        
        for labelNext in nextLabelings {
            let mapNext = labelNext.labeling
            //each currentLabeling is a possible predecessor in this case
            for labelCurr in currentLabelings {
                possiblePredecessors.append(labelCurr)
            }
            
            calcScore(node, possiblePredecessors, mapNext, labelNext)
            possiblePredecessors.removeAll()
        }
        
    }
    
    func calcScore(_ borderNode: CRFNode<T>, _ possiblePredecessor: [CRFLabeling<T>],
                   _ mapNext: [CRFNode<T>: Int], _ labelNext: CRFLabeling<T>){
        
        var max = Double(Int.min)
        var maxPred: CRFLabeling<T>? = nil
        var score = 0.0
        
        //first iteration
        if possiblePredecessor.count == 0 {
            if let label = mapNext[borderNode]{
                max = borderNode.scores[label]
            }
        } else {
            //score = score from predecessor + score from new node + all edge scores to new node
            //find maximum score
            for labelPred in possiblePredecessor {
                score = labelPred.score + borderNode.scores[mapNext[borderNode]!]
                for node in labelPred.labeling.keys {
                    for edge in borderNode.edges {
                        if node.getNeighbor(of: edge) != nil {
                            score += edge.scores[labelPred.labeling[node]!][mapNext[borderNode]!]
                        }
                    }
                }
                if score > max {
                    max = score
                    maxPred = labelPred
                }
            }
            
        }
        labelNext.score = max
    
        //add inner nodes to new labeling
        if maxPred != nil {
            for key in (maxPred?.labeling.keys)! {
                if !(labelNext.labeling.keys.contains(key)){
                    
                }
            }
        }
        if let maxPred = maxPred {
            for key in maxPred.labeling.keys {
                if !labelNext.labeling.keys.contains(key) {
                    labelNext.labeling[key] = maxPred.labeling[key]
                }
            }
        }
        
        
    }
    
    
    
    func createLabeling() {
        var states: [Int] = []
        for i in 0..<numberStates{
            states.append(i)
        }
        let combinations = calcCombinations(border.count, states)
        
        for arr in combinations{
            let labeling = CRFLabeling<T>()
            for i in 0..<arr.count{
                labeling.addLabeling(node: border[i], label: arr[i])
            }
            nextLabelings.append(labeling)
        }
        
    }
    
    func calcCombinations(_ n: Int, _ arr: [Int]) -> [[Int]] {
        var list:[[Int]] = []
        
        let numArrays = Int(pow(Double(arr.count), Double(n)))
        //create each array
        for _ in 0..<numArrays {
            var emptyArr: [Int] = []
            for _ in 0..<n {
                emptyArr.append(0)
            }
            list.append(emptyArr)
        }
        //fill up the array
        for j in 0..<n{
            let period = Int(pow(Double(arr.count), Double(n - j - 1)))
            for i in 0..<numArrays{
                var current:[Int] = list[i]
                let index = i / period % arr.count
                current[j] = arr[index]
                list[i] = current
            }
        }
        
        return list
    }
    
    func updateOutsideEdges(_ node: CRFNode<T>) {
        for edge in node.edges{
            let neighbor = node.getNeighbor(of: edge)
            
            if let neighbor = neighbor{
                if let index = outsideEdges[neighbor]?.index(of: edge){
                    outsideEdges[neighbor]?.remove(at: index)
                }
            }
        }
    }
    
    func updateBorderToInner() {
        let borderCopy = border!
        for node in borderCopy{
            if outsideEdges[node]?.count == 0 {
                inner.append(node)
                if let index = border.index(of: node){
                    border.remove(at: index)
                }
            }
        }
    }

    
    
    
    
    
    
}
