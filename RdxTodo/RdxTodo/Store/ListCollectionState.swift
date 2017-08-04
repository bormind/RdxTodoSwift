//
// Created by Boris Schneiderman on 6/17/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation


enum ListCollectionAction {
  case addTodoList(TodoList)
  case removeTodoList(ListId)
  case setListSort(ListsSorting)
  case changeList(ListId, TodoListAction)
}

enum ListsSorting {
  case byName
  case byLastModified
}

fileprivate func compareDates(_ lhs: TodoListState, _ rhs: TodoListState) -> Bool {
  return lhs.list.lastModified <= rhs.list.lastModified
}

fileprivate func compareNames(_ lhs: TodoListState, _ rhs: TodoListState) -> Bool {
  return lhs.list.name <= rhs.list.name
}


struct ListCollectionState: Equatable {
  var sortBy: ListsSorting = .byLastModified
  var lists: [TodoListState] = []
}

func ==(lhs: ListCollectionState, rhs: ListCollectionState) -> Bool {
  return lhs.sortBy == rhs.sortBy
    && lhs.lists == rhs.lists
}

extension ListCollectionState {

  func sortedLists() -> [TodoList] {

    let compare: (TodoListState, TodoListState) -> Bool
    switch self.sortBy {
      case .byName: compare = compareNames
      case .byLastModified: compare = compareDates
    }

    return self.lists.sorted(by: compare).map { $0.list }
  }

  func listIndex(_ listId: ListId) -> Int? {
    return lists.index(where: { $0.listId == listId })
  }

}

func listCollectionReducer(_ state: ListCollectionState, action: ListCollectionAction)
    -> ListCollectionState {

  var state = state

  switch action {
  case .addTodoList(let list):
    state.lists.append(TodoListState(list: list))
  case .removeTodoList(let id):
    if let ix = state.listIndex(id) {
      state.lists.remove(at: ix)
    }
  case .setListSort(let sort):
    state.sortBy = sort
  case .changeList(let id, let action):
    if let ix = state.listIndex(id) {
      state.lists[ix] = listReducer(state.lists[ix], action: action)
    }
  }

  return state
}

