//
// Created by Boris Schneiderman on 2017-05-06.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

struct TodoListState: Equatable {
  var list: TodoList
  var filterOption: FilterOptions

  init(list: TodoList, filterOption: FilterOptions = .showAll) {
    self.list = list
    self.filterOption = filterOption
  }
}

func ==(lhs: TodoListState, rhs: TodoListState) -> Bool {
  return lhs.list == rhs.list
    && lhs.filterOption == rhs.filterOption
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
}

enum TodoListAction {
  case addItem(TodoItem)
  case removeItem(ListItemId)
  case markAsCompleted(ListItemId, Bool)
  case setFilter(FilterOptions)
}

func listReducer(_ state: TodoListState, action: TodoListAction) -> TodoListState {

  var state = state

  switch action {
  case .addItem(let item):
    state.list.todoItems.append(item)
  case .removeItem(let id):
    if let ix = state.listItemIndex(id) {
      state.list.todoItems.remove(at: ix)
    }
  case .markAsCompleted(let id, let isCompleted):
    if let ix = state.listItemIndex(id) {
      state.list.todoItems[ix].isCompleted = isCompleted
    }
  case .setFilter(let filter):
    state.filterOption = filter
  }

  state.list.lastModified = Date()

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

