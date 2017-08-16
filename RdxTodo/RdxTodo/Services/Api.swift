//
// Created by Boris Schneiderman on 8/16/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

//We pretend that we get shallow list data from the API call
typealias ShallowListData = (listId: ListId, listName: String, lastModified: Date)

struct Api {
  func fetchLists(completed: @escaping (FetchResult<[ShallowListData]>)->()) {
    //simulate async network call
    DispatchQueue.global(qos: .userInitiated).async {
      let resultData = SAMPLE_DATA.map { ($0.id, $0.name, $0.lastModified) }

      Thread.sleep(forTimeInterval: 0.5)
      completed(.value(resultData))
    }
  }

  func fetchTodoList(listId: ListId, completed: @escaping (FetchResult<TodoList>)->()) {
    //simulate async network call
    DispatchQueue.global(qos: .userInitiated).async {
      let result: FetchResult<TodoList>
      if let list = SAMPLE_DATA.first(where: { $0.id == listId } ) {
        result = .value(list)
      }
      else {
        result = .error("List with id: \(listId) not found!")
      }

      Thread.sleep(forTimeInterval: 0.5)
      completed(result)
    }
  }
}