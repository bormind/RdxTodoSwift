//
// Created by Boris Schneiderman on 6/18/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation


//We pretend that we get shallow list data from the API call
typealias ShallowListData = (listId: ListId, listName: String, lastModified: Date)

struct Fetcher {

  static func fetchLists(completed: @escaping (FetchResult<[ShallowListData]>)->()) {
    //simulate async network call
    DispatchQueue.global(qos: .userInitiated).async {
      let resultData = SAMPLE_DATA.map { ($0.id, $0.name, $0.lastModified) }

      Thread.sleep(forTimeInterval: 0.5)
      completed(FetchResult.value(resultData))
    }
  }

}