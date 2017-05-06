//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import RxSwift

private func tempTodos() -> [TodoItem] {
    return ["ASD", "ddfgdg", "err"].enumerated().map { TodoItem(id: $0, todoText: $1) }
}

struct State {
    var todoList: [TodoItem] = tempTodos()
    var filterOption: FilterOptions = .showAll
}

enum Action {
    case addItem(TodoItem)
    case removeItem(Int)
    case markAsCompleted(Int, Bool)
    case setFilter(FilterOptions)
}

typealias Reducer = (State, Action) -> State

fileprivate func reducer(_ state: State, action: Action) -> State {

    var state = state

    switch action {
    case .addItem(let item):
        state.todoList.append(item)
    case .removeItem(let id):
        state.todoList = state.todoList.filter { $0.id != id }
    case .markAsCompleted(let id, let isCompleted):
        if let ix = state.todoList.index(where: { $0.id == id }) {
            state.todoList[ix].isCompleted = isCompleted
        }
    case .setFilter(let filter):
        state.filterOption = filter
    }

    return state

}

class Store {

    let reducer: Reducer

    private let observableState: Variable<State>

    let stateChanges: Observable<(State, State)>

    init(reducer: @escaping Reducer) {
        self.reducer = reducer

        self.observableState = Variable(State())
        self.stateChanges = self.observableState
                                .asObservable()
                                .pairWithPrevious()
                                .observeOn(MainScheduler.instance)
                                .shareReplay(1)
    }

    func dispatch(action: Action) {
        self.observableState.value = self.reducer(self.state, action)
    }

    var state: State {
        return observableState.value
    }
    
    func changedSubstate<Substate>(
            _ getSubstate: @escaping (State)-> Substate,
            _ isChanged: @escaping (Substate, Substate)->Bool) -> Observable<Substate>  {

        return stateChanges
                .map { (getSubstate($0.0), getSubstate($0.1)) }
                .filter(isChanged)
                .map { $0.1 }
    }
}

let gStore = Store(reducer: reducer)
