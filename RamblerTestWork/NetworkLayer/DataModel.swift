//
//  DataModel.swift
//  RamblerTestWork
//
//  Created by Влад Калаев on 27/06/2019.
//  Copyright © 2019 Влад Калаев. All rights reserved.
//

import Foundation

typealias Comments = [Comment]

struct Comment: Codable {
    let id: Int
    let title: String
    let img: String
}
