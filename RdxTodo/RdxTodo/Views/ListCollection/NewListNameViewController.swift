//
// Created by Boris Schneiderman on 7/22/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import UIKit

import Foundation
import StackViews
import RxSwift

final class NewListNameViewController: UIViewController, RdxViewController {

  let newListName = UITextField()
  let createListButton = UIButton()

  let disposableBag = DisposeBag()

  var store: Store?

  init() {
    super.init(nibName: nil, bundle: nil)

    self.view.backgroundColor = UIColor.rgb(218, 226, 242)

    self.newListName.placeholder = "New List Name"
//    self.newListName.layer.borderWidth = 1.0
    self.newListName.backgroundColor = UIColor.white
    self.newListName.addTarget(self, action: #selector(onNameChanged), for: .editingChanged)

    self.createListButton.setTitle("Add", for: .normal)
    self.createListButton.setTitleColor(UIColor.blue, for: .normal)
    self.createListButton.setTitleColor(UIColor.darkGray, for: .disabled)
    self.createListButton.addTarget(self, action: #selector(onAddList), for: .touchUpInside)

    _ = stackViews(
      container: self.view,
      orientation: .horizontal,
      justify: .fill,
      align: .center,
      insets: Insets(top: 0, left: 5, bottom: 0, right: 0),
      spacing: 2,
      views: [newListName, createListButton],
      widths: [nil, 60]).container
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(_ env: Environment) {
    self.store = env.store

    self.store?.state
      .map { $0.newListState }
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] in self.updateUI($0) })
      .addDisposableTo(disposableBag)
  }

  private func updateUI(_ newListState: NewListState) {

    self.createListButton.isEnabled = newListState.addListButtonEnabled
    if self.newListName.text != newListState.newName {
      self.newListName.text = newListState.newName
    }
  }

  func onAddList() {
    guard let name = store?.currentState.newListState.newName else {
      return
    }

    let newTodoList = TodoList(name: name)
    self.store?.dispatch(Action(.addOrUpdateTodoList(newTodoList)))
    self.store?.dispatch(Action(.clearNewListName))
  }

  func onNameChanged() {
    guard let newName = self.newListName.text else {
      return
    }

    self.store?.dispatch(Action(.setNewListName(newName)))
  }
}