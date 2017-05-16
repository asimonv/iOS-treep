//
//  Teacher.swift
//  treep
//
//  Created by Andre Simon on 12/13/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import Foundation

struct Teacher {
    let imageURL : String
    let name : String
    let id: Int32
    let popularity: Int32
    let disposition: Float
    let exigency: Float
    let knowledge: Float
    let clarity: Float
    let factor: Float
    
    var votes: [String: Any]
    
    init(imageURL: String, name: String, id: Int32, popularity: Int32, disposition: Float, exigency: Float, knowledge: Float, clarity: Float, factor: Float, votes: [String: Any]) {
        self.imageURL = imageURL
        self.name = name
        self.id = id
        self.popularity = popularity
        self.disposition = disposition
        self.exigency = exigency
        self.knowledge = knowledge
        self.clarity = clarity
        self.factor = factor
        self.votes = votes
    }
}
