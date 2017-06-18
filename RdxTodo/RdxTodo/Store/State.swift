//
// Created by Boris Schneiderman on 2017-05-06.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

typealias ListId = UUID
typealias ListItemId = UUID


struct State {
  var listCollection: ListCollectionState = ListCollectionState()
  var selectedListId: ListId? = nil
}

extension State {
  var selectedList: TodoListState? {
    guard let id = self.selectedListId else {
      return nil
    }

    return self.listCollection.lists.first(where: { $0.listId == id })
  }
}

enum Action {
  case selectList(ListId)
  case listCollectionAction(ListCollectionAction)
  case todoListAction(ListId, TodoListAction)
}

extension Action {
  init(_ id: ListId, _ listAction: TodoListAction) {
    self = .todoListAction(id, listAction)
  }
}

func reducer(_ state: State, action: Action) -> State {

  var state = state

  switch action {
  case .selectList(let listId):
    state.selectedListId = listId
  case .listCollectionAction(let listCollectionAction):
    state.listCollection = listCollectionReducer(state.listCollection, action: listCollectionAction)
  case .todoListAction(let listId, let action):
    if let ix = state.listCollection.lists.index(where: { $0.listId == listId }) {
      state.listCollection.lists[ix] = listReducer(state.listCollection.lists[ix], action: action)
    }
  }

  return state
}





