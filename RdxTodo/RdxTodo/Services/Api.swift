//
// Created by Boris Schneiderman on 8/16/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import RxSwift

struct FetchError : Error, CustomStringConvertible {
  let message: String

  init(_ message: String) {
    self.message = message
  }

  public var description: String {
    return message
  }
}

//We pretend that we get shallow list data from the API call
typealias ShallowListData = (listId: ListId, listName: String, lastModified: Date)

struct Api {
  func fetchLists() -> Observable<[ShallowListData]> {
    return Observable.create { observer in
      //simulate async network call
      DispatchQueue.global(qos: .userInitiated).async {
        Thread.sleep(forTimeInterval: 0.5)

        let data = SAMPLE_DATA.map { ($0.id, $0.name, $0.lastModified) }
        observer.on(.next(data))
        observer.on(.completed)
      }

      return Disposables.create()
    }

  }

  func fetchTodoList(listId: ListId) -> Observable<TodoList> {
    return Observable.create { observer in
      //simulate async network call
      DispatchQueue.global(qos: .userInitiated).async {
        Thread.sleep(forTimeInterval: 2)

        if listId == BROKEN_LIST_ID {
          observer.on(.error(FetchError("List data not found!")))
        }

        guard let list = SAMPLE_DATA.first(where: { $0.id == listId } ) else {
          observer.on(.error(FetchError("List with id: \(listId) not found!")))
          return
        }

        observer.on(.next(list))
        observer.on(.completed)
      }

      return Disposables.create()
    }
  }
}