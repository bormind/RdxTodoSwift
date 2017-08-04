//
// Created by Boris Schneiderman on 8/4/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

enum NewListAction {
  case clearNewListName
  case setNewListName(String)
}

struct NewListState: Equatable {
  var newName: String? = nil
  var addListButtonEnabled: Bool = false
}

func ==(lhs: NewListState, rhs: NewListState) -> Bool {
  return lhs.newName == rhs.newName
    && lhs.addListButtonEnabled == rhs.addListButtonEnabled
}

fileprivate func isAddListButtonEnabled(_ state: NewListState) -> Bool {
  return !(state.newName ?? "").isEmpty
}

func newListReducer(_ state: NewListState, action: NewListAction) -> NewListState {
  var state = state

  switch action {
  case .setNewListName(let name):
    state.newName = name
    state.addListButtonEnabled = isAddListButtonEnabled(state)
  case .clearNewListName:
    state.newName = nil
    state.addListButtonEnabled = isAddListButtonEnabled(state)
  }

  return state
}