//
//  SectionViewModel.swift
//  Combine & CollectionView Sample App
//
//  Created by Ali Bahadori on 13.01.21.
//

import Foundation

struct SectionViewModel: Hashable {
    let userName: String
    let todos: [TodoCellViewModel]
}

