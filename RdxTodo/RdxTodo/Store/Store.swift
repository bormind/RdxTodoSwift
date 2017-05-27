//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import RxSwift

typealias Reducer = (State, Action) -> State

private func tempTodos() -> [TodoItem] {
    return ["ASD", "ddfgdg", "err"].enumerated().map { TodoItem(id: $0, todoText: $1) }
}


typealias ID = UUID

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
