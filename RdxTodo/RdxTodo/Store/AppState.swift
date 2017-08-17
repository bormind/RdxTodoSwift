//
// Created by Boris Schneiderman on 2017-05-06.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

typealias ListId = UUID
typealias ListItemId = UUID
typealias ChangeId = UUID

protocol ChangeTracking {
  var changeId: ChangeId { get set }
}

struct AppState: Equatable, ChangeTracking {
  var listCollection: ListCollectionState
  var selectedListId: ListId? = nil
  var newListState = NewItemState()
  var newTodoItemState = NewItemState()
  var changeId: ChangeId

  init(listCollection: ListCollectionState, changeId: ChangeId) {
    self.listCollection = listCollection
    self.changeId = changeId
  }
}

func ==(lhs: AppState, rhs: AppState) -> Bool {
  return lhs.changeId == rhs.changeId
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

func reducer(_ state: AppState, action: Action, changeId: ChangeId) -> AppState {

  var state = state
  state.changeId = changeId

  switch action {
   case .selectList(let listId):
    state.selectedListId = listId
  case .listCollectionAction(let listCollectionAction):
    state.listCollection = listCollectionReducer(state.listCollection, action: listCollectionAction, changeId: changeId)
  case .todoListAction(let listId, let action):
    if let ix = state.listCollection.lists.index(where: { $0.listId == listId }) {
      state.listCollection.lists[ix] = listReducer(state.listCollection.lists[ix], action: action, changeId: changeId)
    }
  case .newListAction(let action):
    state.newListState = newItemReducer(state.newListState, action: action)
  case .newTodoItemAction(let action):
    state.newTodoItemState = newItemReducer(state.newTodoItemState, action: action)
  }

  return state
}





