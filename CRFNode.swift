//
//  CRFNode.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation

class CRFNode<T>{
    
    var data: T!
    var position: Int
    var currentLabel: Int
    
    //node has different score for each possible label given observation
    var scores: [Double]
    var edges: [CRFEdge<T>]
    
    init() {
        position = 0
        currentLabel = 0
        scores = []
        edges = []
    }
    
    func addEdge(edge: CRFEdge<T>){
        edges.append(edge)
    }
    
    func currentScore() -> Double{
        return scores[currentLabel]
    }
    
    //get neighbor for edge
    func getNeighbor(of edge: CRFEdge<T>) -> CRFNode<T>?{
        var node:CRFNode<T>? = nil
        
        for currentEdge in edges {
            if (edge == currentEdge){
                
                if (edge.foot == self){
                    node = edge.head
                } else if (edge.head == self){
                    node = edge.foot
                }
            }
        }
        
        return node
    }
}

extension CRFNode : Hashable{
    
    var hashValue: Int {
        return position.hashValue
    }
    
    static func == (lhs: CRFNode<T>, rhs: CRFNode<T>) -> Bool {
        return lhs.position == rhs.position
    }
}

extension CRFNode : CustomStringConvertible{
    var description: String{
        return "node_\(position)"
    }
}
