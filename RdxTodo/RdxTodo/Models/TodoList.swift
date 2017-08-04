//
// Created by Boris Schneiderman on 6/17/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

struct TodoList: Equatable{
  let id: ListId
  let name: String
  var lastModified: Date
  var todoItems: [TodoItem]

  init(id: ListId = ListId(), name: String, lastModified: Date = Date(), todoItems: [TodoItem] = []) {
    self.id = id
    self.name = name
    self.lastModified = lastModified
    self.todoItems = todoItems
  }
}

func ==(lhs: TodoList, rhs: TodoList) -> Bool {
  return lhs.id == rhs.id
    && lhs.name == rhs.name
    && lhs.lastModified == rhs.lastModified
    && lhs.todoItems == rhs.todoItems
}