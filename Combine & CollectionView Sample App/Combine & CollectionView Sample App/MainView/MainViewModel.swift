//
//  MainViewModel.swift
//  Combine & CollectionView Sample App
//
//  Created by Ali Bahadori on 13.01.21.
//

import Foundation
import Combine

final class MainViewModel{
    
    // MARK: - Properties
    
    private var webService: WebService!
    private var cancellable: Set<AnyCancellable> = Set()
    var sectionViewModels: [SectionViewModel] = []
    var onShowError: (Error)->() = { _ in }
    var onUpdate: ()->() = {}
    
    //MARK: - Inits
    
    init(webService: WebService = WebService()){
        self.webService = webService
    }
    
    //MARK: - Fetching Data Functions
    
    func fetchData(){
        let usersPublisher = webService.fetchUsers()
        let todosPublisher = webService.fetchTodos()

        Publishers.CombineLatest(usersPublisher, todosPublisher)
            .receive(on: RunLoop.main)
            .tryMap { result -> [SectionViewModel] in
                return result.0.map { user -> SectionViewModel in
                    
                    let todos = result.1.filter { $0.userId == user.id }
                    
                    let todoViewModels = todos.map { todo -> TodoCellViewModel in
                        return TodoCellViewModel(title: todo.title, completed: todo.completed)
                    }
                    
                    return SectionViewModel(userName: user.name, todos: todoViewModels)
                }
            }
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.onShowError(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (viewModels) in
                self?.sectionViewModels = viewModels
                self?.onUpdate()
            }).store(in: &cancellable)
    }
}
