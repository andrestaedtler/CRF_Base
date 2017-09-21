//
//  GraphCreator.swift
//  CRF Base
//
//  Created by Andre Staedtler on 19.09.17.
//  Copyright © 2017 Andre Staedtler. All rights reserved.
//

import Foundation

//generate graphs
struct GraphCreator{
    
    static let attituteToPartyMappings = [
        [0.3, 0.7],
        [0.5, 0.5],
        [0.7, 0.3]
    ]
    
    static let sameParty = 0.1
    static let differentParty = 0.0
    static let edgeScores = [[sameParty, differentParty], [differentParty, sameParty]]
    
    
    static func createGraphRectangle() -> CRFGraph<Person> {
        
        let numberNodes = 4
        let numberEdges = 4
        let graph = CRFGraph<Person>()
        
        //create nodes
        for i in 0..<numberNodes{
            let node = CRFNode<Person>()
            let person = Person(getRandomAttitute())
            node.data = person
            node.position = i
            node.scores = attituteToPartyMappings[person.attitute.rawValue]
            node.data?.name = "person_\(i)"
            graph.nodes.append(node)
        }
        
        for i in 0..<numberEdges{
            let edge = CRFEdge<Person>(foot: graph.nodes[i], head: graph.nodes[(i + 1) % numberNodes])
            edge.scores = edgeScores
            graph.edges.append(edge)
        }
        
        return graph
    }
    
    static func createGraphGrid2d() -> CRFGraph<Person> {
        let dimX = 3
        let dimY = 4
        let graph = CRFGraph<Person>()
        var grid: [[CRFNode<Person>]] = Array(repeating: Array(repeating: CRFNode<Person>(), count: dimY), count: dimX)
        var position = 0
        for x in 0..<dimX{
            for y in 0..<dimY{
                let node = CRFNode<Person>()
                let person = Person(getRandomAttitute())
                node.data = person
                node.position = position
                node.scores = attituteToPartyMappings[person.attitute.rawValue]
                grid[x][y] = node
                graph.nodes.append(node)
                position += 1
            }
        }
        
        for x in 0..<dimX {
            for y in 0..<dimY {
                if x < dimX - 1 {
                    let edge = CRFEdge<Person>(foot: grid[x][y], head: grid[(x + 1) % dimX][y])
                    edge.scores = edgeScores
                    graph.edges.append(edge)
                }
                if y < dimY - 1 {
                    let edge = CRFEdge<Person>(foot: grid[x][y], head: grid[x][(y + 1) % dimY])
                    edge.scores = edgeScores
                    graph.edges.append(edge)
                }
            }
        }
        
        return graph
    }
    
    
    
    
    
}
