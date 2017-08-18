//
// Created by Boris Schneiderman on 2017-05-06.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

struct TodoListState: Equatable, ChangeTracking {
  var list: TodoList
  var filterOption: FilterOptions
  var changeId: ChangeId
  var isFetchingListData = false
  var fetchingError: String? = nil

  init(list: TodoList, filterOption: FilterOptions = .showAll, changeId: ChangeId) {
    self.list = list
    self.filterOption = filterOption
    self.changeId = changeId
  }
}

func ==(lhs: TodoListState, rhs: TodoListState) -> Bool {
  return lhs.listId == rhs.listId
    && lhs.changeId == rhs.changeId
}

extension TodoListState {
  var listId: ListId {
    return self.list.id
  }

  func listItemIndex(_ id: ListItemId) -> Int? {
    return self.list.todoItems.index(where: { $0.id == id })
  }

  func visibleAndSortedItems() -> [TodoItem] {
    return list.todoItems
      .filter(isListItemVisible(self.filterOption))
      .sorted(by: compareListItems)
  }

  var needsRefreshing: Bool {
    return self.list.todoItems.isEmpty
  }
}

enum TodoListAction {
  case addItem(TodoItem)
  case removeItem(ListItemId)
  case markAsCompleted(ListItemId, Bool)
  case setFilter(FilterOptions)
  case setIsFetching(Bool)
  case setFetchingError(String?)
}

func listReducer(_ state: TodoListState, action: TodoListAction, changeId: ChangeId) -> TodoListState {

  var state = state
  state.changeId = changeId

  switch action {
  case .addItem(let item):
    state.list.todoItems.append(item)
    state.list.lastModified = Date()
  case .removeItem(let id):
    if let ix = state.listItemIndex(id) {
      state.list.todoItems.remove(at: ix)
      state.list.lastModified = Date()
    }
  case .markAsCompleted(let id, let isCompleted):
    if let ix = state.listItemIndex(id) {
      state.list.todoItems[ix].isCompleted = isCompleted
      state.list.lastModified = Date()
    }
  case .setFilter(let filter):
    state.filterOption = filter
  case .setIsFetching(let isFetching):
    state.isFetchingListData = isFetching
  case .setFetchingError(let fetchingError):
    state.fetchingError = fetchingError
  }

  return state
}

fileprivate func isListItemVisible(_ filterOption: FilterOptions)
    -> (TodoItem)
    -> Bool {

  return { todoItem in
    switch filterOption {
    case .showAll:
      return true
    case .showCompleted:
      return todoItem.isCompleted
    case .showActive:
      return !todoItem.isCompleted
    }
  }
}

fileprivate func compareListItems(_ lhs: TodoItem, _ rhs: TodoItem) -> Bool {
  if lhs.isCompleted != rhs.isCompleted {
    return rhs.isCompleted
  }

  return lhs.todoText.caseInsensitiveCompare(rhs.todoText) == .orderedAscending
}

