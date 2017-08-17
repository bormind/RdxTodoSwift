//
// Created by Boris Schneiderman on 6/18/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

struct Fetcher {
  let api: Api
  let store: Store

  func fetchLists() {
    api.fetchLists { result in
      _ = result
        .onValue { listsData in
          listsData
            .map { TodoList(id: $0.listId, name: $0.listName, lastModified: $0.lastModified) }
            .forEach { self.store.dispatch(.listCollectionAction(.addOrUpdateTodoList($0))) }
        }
        .onError {  print("Error fetching Lists: \($0)")  }
    }
  }

  func fetchListDetails(listId: ListId) {
    api.fetchTodoList(listId: listId) { result in
      _ = result
        .onValue { self.store.dispatch(.listCollectionAction(.addOrUpdateTodoList($0))) }
        .onError {  print("Error fetching list details: \($0)")  }
    }
  }
}