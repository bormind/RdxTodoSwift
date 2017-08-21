//
// Created by Boris Schneiderman on 6/18/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import RxSwift

struct Fetcher {
  let api: Api
  let store: Store

  func fetchLists() {
    _ = api.fetchLists()
      .subscribe(onNext: { listsData in
        listsData
          .map { TodoList(id: $0.listId, name: $0.listName, lastModified: $0.lastModified) }
          .forEach { self.store.dispatch(.listCollectionAction(.addOrUpdateTodoList($0))) }
        },
        onError: { print("Error fetching Lists: \($0)") }
      )

  }

  func fetchListDetails(listId: ListId) {
    self.store.dispatch(.todoListAction(listId, .setIsFetching(true)))

    _ = api.fetchTodoList(listId: listId)
      .subscribe(
        onNext: { self.store.dispatch(.listCollectionAction(.addOrUpdateTodoList($0))) },
        onError: {
          self.store.dispatch(.todoListAction(listId, .setFetchingError("\($0)")))
        }
      )

  }
}