//
//  main.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation


var graph = GraphCreator.createGraphRectangle()
let mapPrediction = MAPPredictionCRF<Person>()
let label = mapPrediction.calcMAP(queue: graph.nodes, numberStates: 2)
var resultArray: [Int] = []
for _ in 0..<label.labeling.count {
    resultArray.append(-1)
}
for entry in label.labeling{
    resultArray[entry.key.position] = entry.value
}
print("Maximizing labeling - MAP: ")
for i in resultArray {
    print("\(i)", terminator: " ")
}
print("\nwith score: \(label.score)")


print("\nMaximizing labeling - Brutforce: ")
let brutforce = BrutforceCRF<Person>()
brutforce.brutforce(graph: graph, numberLabels: 2)
