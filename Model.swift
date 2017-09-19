//
//  Model.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation

//Observation X
enum Attitute: Int {
    case White
    case Grey
    case Black
    
}

func getRandomAttitute() -> Attitute{
    let random = Int(arc4random_uniform(3))
    return Attitute(rawValue: random)!
}

//Label Y
enum Party: Int {
    case Green
    case Blue
}

class Person {
    var attitute: Attitute
    var name: String
    
    init(_ attitute: Attitute) {
        self.attitute = attitute
        name = ""
    }
}
