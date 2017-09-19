//
//  CRFLabeling.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation

class CRFLabeling<T> {
    
    var labeling: [CRFNode<T> : Int]
    var score: Double
    
    init() {
        labeling = [:]
        score = 0
    }
    
    func addLabeling(node: CRFNode<T>, label: Int) {
        labeling[node] = label
    }
    
    
}

extension CRFLabeling: CustomStringConvertible{
    
    var description:String {
        var s = ""
        for label in labeling {
            s += "\(label.key) + has label \(label.value) "
        }
        s += "Score:  \(score) + \n"
        return s
    }
}
