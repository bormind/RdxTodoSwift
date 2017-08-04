//
// Created by Boris Schneiderman on 6/18/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

//this is ad hoc Result handling for simplicity and demo only
//better approach would be to have "proper" Result object with bind and apply capabilities or to
//use one fro RxSwift or other library
enum FetchResult<T> {
  case value(T)
  case error(String)
}

extension FetchResult {

  func onValue(f: (T)->()) -> FetchResult<T> {
    switch self {
      case .value(let v):
        f(v)
        return self
      case .error:
        return self
    }
  }

  func onError(f: (String)->()) -> FetchResult<T> {
    switch self {
      case .value:
        return self
      case .error(let message):
        f(message)
        return self
    }
  }
}