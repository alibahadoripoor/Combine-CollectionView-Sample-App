//
//  WebService.swift
//  Combine & CollectionView Sample App
//
//  Created by Ali Bahadori on 13.01.21.
//

import Foundation
import Combine

final class WebService{
    
    // MARK: - Properties
    
    private var urlComponents: URLComponents = {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = EndPoints.scheme
        urlBuilder.host = EndPoints.host
        return urlBuilder
    }()
    
    //MARK: - Fetching Data Functions
    
    func fetchUsers() -> AnyPublisher<[User], Error> {
        urlComponents.path = EndPoints.usersPath
        
        return URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchTodos() -> AnyPublisher<[Todo], Error> {
        urlComponents.path = EndPoints.todosPath
        
        return URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map { $0.data }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
