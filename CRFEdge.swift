//
//  CRFEdge.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation

class CRFEdge<T> {
    
    var scores: [[Double]]
    var foot: CRFNode<T>
    var head: CRFNode<T>
    
    init(foot: CRFNode<T>, head: CRFNode<T>) {
        self.foot = foot
        self.head = head
        scores = []
        foot.addEdge(edge: self)
        head.addEdge(edge: self)
    }
    
    func currentScore() -> Double {
        return scores[foot.currentLabel][head.currentLabel]
    }
    
}

extension CRFEdge: Equatable {
    
    static func == (lhs: CRFEdge<T>, rhs: CRFEdge<T>) -> Bool {
        return lhs.foot.position == rhs.foot.position && lhs.head.position == rhs.head.position
    }
    
}

extension CRFEdge: CustomStringConvertible {
    var description: String {
        return "edge footID_\(foot.position), headId_\(head.position)"
    }
}
