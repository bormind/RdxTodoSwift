//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import RxSwift

typealias Reducer = (AppState, Action) -> AppState


class Store {

  let reducer: Reducer

  private let observableState: Variable<AppState>

  init(reducer: @escaping Reducer) {
    self.reducer = reducer

    self.observableState = Variable(AppState())
  }

  func dispatch(_ action: Action) {
    self.observableState.value = self.reducer(self.observableState.value, action)
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

