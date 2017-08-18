//
// Created by Boris Schneiderman on 8/4/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

enum NewItemAction {
  case clearNewItemName
  case setNewItemName(String)
}

struct NewNameState: Equatable {
  var newName: String? = nil
  var addItemButtonEnabled: Bool = false
}

func ==(lhs: NewNameState, rhs: NewNameState) -> Bool {
  return lhs.newName == rhs.newName
    && lhs.addItemButtonEnabled == rhs.addItemButtonEnabled
}

fileprivate func isAddItemButtonEnabled(_ state: NewNameState) -> Bool {
  return !(state.newName ?? "").isEmpty
}

func newNameReducer(_ state: NewNameState, action: NewItemAction) -> NewNameState {
  var state = state

  switch action {
  case .setNewItemName(let name):
    state.newName = name
    state.addItemButtonEnabled = isAddItemButtonEnabled(state)
  case .clearNewItemName:
    state.newName = nil
    state.addItemButtonEnabled = isAddItemButtonEnabled(state)
  }

  return state
}