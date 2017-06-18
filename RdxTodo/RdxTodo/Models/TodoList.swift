//
// Created by Boris Schneiderman on 6/17/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

struct TodoList: Equatable{
  let id: ListId
  let name: String
  var lastWatched: Date

  var todoItems: [TodoItem] = []
}

func ==(lhs: TodoList, rhs: TodoList) -> Bool {
  return lhs.id == rhs.id
    && lhs.name == rhs.name
    && lhs.lastWatched == rhs.lastWatched
    && lhs.todoItems == rhs.todoItems
}