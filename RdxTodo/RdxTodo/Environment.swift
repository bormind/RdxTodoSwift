//
// Created by Boris Schneiderman on 8/16/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

class Environment {
  let store: Store
  let fetcher: Fetcher

  init(store: Store, fetcher: Fetcher) {
    self.store = store
    self.fetcher = fetcher
  }
}