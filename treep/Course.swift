//
//  Course.swift
//  treep
//
//  Created by Andre Simon on 12/19/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import Foundation

struct Course {
    
    var id: Int32
    var sigla: String
    var name: String
    var isEndorsed: Bool
    var endorses: Int32
    var factor: Float
    var credits: Int32
    
    var popularity: Int32
    var difficulty: Float
    var workload: Float
    var interesting: Float
    var bestTeacher: Teacher?
    
    var votes: [String: Any]
    
    init(id: Int32, popularity: Int32, difficulty: Float, workload: Float, interesting: Float, sigla: String, name: String, credits: Int32, votes: [String: Any], isEndorsed: Bool = false, endorses: Int32 = 0, factor: Float = 0, bestTeacher: Teacher? = nil) {
        self.id = id
        self.popularity = popularity
        self.difficulty = difficulty
        self.workload = workload
        self.interesting = interesting
        self.sigla = sigla
        self.name = name
        self.isEndorsed = isEndorsed
        self.endorses = endorses
        self.credits = credits
        self.votes = votes
        self.factor = factor
        self.bestTeacher = bestTeacher
        
    }
    
}
