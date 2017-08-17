//
// Created by Boris Schneiderman on 2017-05-06.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

typealias ListId = UUID
typealias ListItemId = UUID


struct AppState {
  var listCollection: ListCollectionState = ListCollectionState()
  var selectedListId: ListId? = nil
  var newListState = NewItemState()
  var newTodoItemState = NewItemState()
}

extension AppState {
  var selectedList: TodoListState? {
    return self.selectedListId.flatMap { self.listCollection.getList(withId: $0) }
  }
}

enum Action {
  case selectList(ListId)
  case listCollectionAction(ListCollectionAction)
  case todoListAction(ListId, TodoListAction)
  case newListAction(NewItemAction)
  case newTodoItemAction(NewItemAction)
}

func reducer(_ state: AppState, action: Action) -> AppState {

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
  case .newListAction(let action):
    state.newListState = newItemReducer(state.newListState, action: action)
  case .newTodoItemAction(let action):
    state.newTodoItemState = newItemReducer(state.newTodoItemState, action: action)
  }

  return state
}





