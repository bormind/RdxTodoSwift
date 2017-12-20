//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

struct TodoItem: Equatable {
  let id: ListItemId
  let todoText: String
  var isCompleted = false

  init(id: ListItemId, todoText: String) {
    self.id = id
    self.todoText = todoText
  }
}

func ==(lhs: TodoItem, rhs: TodoItem) -> Bool {
  return lhs.id == rhs.id
    && lhs.todoText == rhs.todoText
    && lhs.isCompleted == rhs.isCompleted
}