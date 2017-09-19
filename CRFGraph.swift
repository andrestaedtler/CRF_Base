//
//  CRFGraph.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation

class CRFGraph<T> {
    
    var nodes: [CRFNode<T>]
    var edges: [CRFEdge<T>]
    
    init() {
        nodes = []
        edges = []
    }
    
    func currentScore() -> Double {
        var score = 0.0
        for node in nodes {
            score += node.currentScore()
        }
        for edge in edges {
            score += edge.currentScore()
        }
        
        return score
    }
}

extension CRFGraph: CustomStringConvertible{
    
    var description:String {
        var s = "NODES:\n"
        for node in nodes {
            s += "\(node)\n"
        }
        s += "EDGES:\n"
        for edge in edges {
            s += "\(edge)\n"
        }
        
        return s
    }
}
