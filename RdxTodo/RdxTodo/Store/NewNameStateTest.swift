//
// Created by Boris Schneiderman on 8/22/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

import XCTest
import RxSwift
import RxTest
@testable import RdxTodo

extension RxTest.TestableObserver {
  var values: [ElementType?] {
    return self.events.map { $0.value.element }
  }
}

func ==<T: Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
  guard lhs.count == rhs.count else {
    return false
  }

  for i in 0..<lhs.count  {
    if lhs[i] != rhs[i] {
      return false
    }
  }

  return true
}

extension XCTestCase {
  public func XCTAssertEqual<T: Equatable>(
    _ expression1: @autoclosure () -> Array<T?>,
    _ expression2: @autoclosure () -> Array<T?>,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line) where T : Equatable {

    let exp1 = expression1()
    let exp2 = expression2()

    if exp1 == exp2 {
      return
    }

    XCTFail(message ?? "\(exp1) is not equal to \(exp2)", file: file, line: line)
  }

}

class NewNameStateTest: XCTestCase {

  private var textObserver: TestableObserver<String>!
  private var enabledObserver: TestableObserver<Bool>!
  private var env: Environment!

  override func setUp() {
    super.setUp()

    let scheduler = TestScheduler(initialClock: 0)
    self.textObserver = scheduler.createObserver(String.self)
    self.enabledObserver = scheduler.createObserver(Bool.self)

    let store = Store(reducer: reducer)
    let api = Api()
    let fetcher = Fetcher(api: api, store: store)
    self.env = Environment(store: store, fetcher: fetcher)

  }

  var state: Observable<AppState> {
    return self.env.store.state
  }

  func testAddButton() {
    let disposeBag = DisposeBag()

    self.state
      .mapChange { $0.newListNameState.newName ?? "" }
      .subscribe(self.textObserver)
      .addDisposableTo(disposeBag)

    self.state
      .mapChange { $0.newListNameState.addItemButtonEnabled }
      .subscribe(self.enabledObserver)
      .addDisposableTo(disposeBag)

    XCTAssertEqual(self.textObserver.values, [""])
    XCTAssertEqual(self.enabledObserver.values, [false])

    env.store.dispatch(.newListNameAction(.setNewItemName("Boo")))

    XCTAssertEqual(self.textObserver.values, ["", "Boo"])
    XCTAssertEqual(self.enabledObserver.values, [false, true])

    env.store.dispatch(.newListNameAction(.setNewItemName("")))

    XCTAssertEqual(self.textObserver.values, ["", "Boo", ""])
    XCTAssertEqual(self.enabledObserver.values, [false, true, false])

  }
}
