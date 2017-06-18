//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import RxSwift

typealias Reducer = (State, Action) -> State


class Store {

  let reducer: Reducer

  private let observableState: Variable<State>

  init(reducer: @escaping Reducer) {
    self.reducer = reducer

    self.observableState = Variable(State())
  }

  func dispatch(_ action: Action) {
    self.observableState.value = self.reducer(self.observableState.value, action)
  }

  var state: Observable<State> {
    return observableState.asObservable()
  }

  var currentState: State {
    return observableState.value
  }

}

let gStore = Store(reducer: reducer)
