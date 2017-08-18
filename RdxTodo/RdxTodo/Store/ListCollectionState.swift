//
// Created by Boris Schneiderman on 6/17/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation


enum ListCollectionAction {
  case addOrUpdateTodoList(TodoList)
  case removeTodoList(ListId)
  case setListSort(ListsSorting)
  case changeList(ListId, TodoListAction)
}

enum ListsSorting {
  case byName
  case byLastModified
}

struct ListCollectionState: Equatable, ChangeTracking {
  var sortBy: ListsSorting = .byLastModified
  var lists: [TodoListState] = []
  var changeId: ChangeId

  init(changeId: ChangeId) {
    self.changeId = changeId
  }
}

func ==(lhs: ListCollectionState, rhs: ListCollectionState) -> Bool {
  return lhs.changeId == rhs.changeId
}

extension ListCollectionState {

  func sortedLists() -> [TodoListState] {

    let compare: (TodoListState, TodoListState) -> Bool
    switch self.sortBy {
      case .byName: compare = compareNames
      case .byLastModified: compare = compareDates
    }

    return self.lists.sorted(by: compare)
  }

  func listIndex(_ listId: ListId) -> Int? {
    return lists.index(where: { $0.listId == listId })
  }

  func getList(withId: ListId) -> TodoListState? {
    return lists.first(where: { $0.listId == withId })
  }

}

func listCollectionReducer(_ state: ListCollectionState, action: ListCollectionAction, changeId: ChangeId)
    -> ListCollectionState {

  var state = state
  state.changeId = changeId

  switch action {
  case .addOrUpdateTodoList(let list):
    if let ix = state.listIndex(list.id) {
      let localListState = state.lists[ix]
      state.lists[ix] = TodoListState(
        list: consolidateLists(local: localListState.list, remote: list),
        filterOption: localListState.filterOption,
        changeId: changeId)
    }
    else {
      state.lists.append(TodoListState(list: list, changeId: changeId))
    }
  case .removeTodoList(let id):
    if let ix = state.listIndex(id) {
      state.lists.remove(at: ix)
    }
  case .setListSort(let sort):
    state.sortBy = sort
  case .changeList(let id, let action):
    if let ix = state.listIndex(id) {
      state.lists[ix] = listReducer(state.lists[ix], action: action, changeId: changeId)
    }
  }

  return state
}

fileprivate func compareDates(_ lhs: TodoListState, _ rhs: TodoListState) -> Bool {
  return lhs.list.lastModified >= rhs.list.lastModified
}

fileprivate func compareNames(_ lhs: TodoListState, _ rhs: TodoListState) -> Bool {
  return lhs.list.name <= rhs.list.name
}

//This is for example only in real life consolidation should happen on the server
//when changes are made and only reflected in the local state in the store
fileprivate func consolidateLists(local: TodoList, remote: TodoList) -> TodoList {
  return local.lastModified > remote.lastModified ? local : remote
}
