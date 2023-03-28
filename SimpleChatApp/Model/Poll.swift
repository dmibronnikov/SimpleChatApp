//
//  Poll.swift
//  SimpleChat
//
//  Created by Dmitriy Bronnikov on 27.03.2023.
//

import Foundation

struct Poll {
    struct Option {
        let id: Int
        let text: String
        let votes: Int
    }
    
    let id: Int
    let question: String
    let options: [Option]
    
    var votes: Int { options.reduce(0, { $0 + $1.votes }) }
}
