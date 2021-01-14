//
//  Todo.swift
//  Combine & CollectionView Sample App
//
//  Created by Ali Bahadori on 13.01.21.
//

import Foundation

struct Todo: Codable{
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}
