//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import RxSwift

typealias Reducer = (AppState, Action, ChangeId) -> AppState


class Store {

  let reducer: Reducer

  private let observableState: Variable<AppState>

  init(reducer: @escaping Reducer) {
    self.reducer = reducer

    let changeId = ChangeId()
    let initialState = AppState(listCollection: ListCollectionState(changeId: changeId), changeId: changeId)

    self.observableState = Variable(initialState)
  }

  func dispatch(_ action: Action) {
    print("Action: \(action)")
    print("Before: \(self.currentState)")
    self.observableState.value = self.reducer(self.observableState.value, action, ChangeId())
    print("After: \(self.currentState)")
  }

  var state: Observable<AppState> {
    return observableState
      .asObservable()
      .observeOn(MainScheduler.instance)
  }

  var currentState: AppState {
    return observableState.value
  }

}

