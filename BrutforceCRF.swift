//
//  BrutforceCRF.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation

//Calcs all possible labels and the maximizing label to check if MAP prediction works
//has exponential run-time -> should only be used on small graphs to verify
class BrutforceCRF<T> {
    
    func brutforce(graph: CRFGraph<T>, numberLabels: Int) {
        var labels:[Int] = []
        for l in 0..<numberLabels {
            labels.append(l)
        }
        
        let labelCombinations = calcCombinations(graph.nodes.count, labels)
        print("\(labelCombinations.count) possible labelcombinations")
        var maxScore = 0.0
        var maxLabels:[String] = []
        for labelComb in labelCombinations {
            
            var index = 0
            var s = ""
            for node in graph.nodes {
                node.currentLabel = labelComb[index]
                s += "\(labelComb[index]) "
                index += 1
            }
            if graph.currentScore() > maxScore {
                maxScore = graph.currentScore()
                maxLabels.removeAll()
                maxLabels.append(s)
            } else if graph.currentScore() == maxScore{
                maxLabels.append(s)
            }
            print("\(s) Score: \(graph.currentScore())")
        }
        print("")
        for label in maxLabels {
            print("Maximizing labeling: \(label)")
        }
        print("with score: \(maxScore)")
    }
    
    
    func calcCombinations(_ n: Int, _ arr: [Int]) -> [[Int]] {
        
        let numArrays = Int(pow(Double(arr.count), Double(n)))
        var list = Array(repeating: Array(repeating: 0, count: n), count: numArrays)
        
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
    
}
