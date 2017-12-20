//
// Created by Boris Schneiderman on 7/22/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import UIKit

import Foundation
import StackViews
import RxSwift

protocol AddNewItemDelegate: class {
  func onAddNewItem(name: String)
  func onItemNameChanged(newName: String)
}

final class NewItemNameViewController: UIViewController {

  let newListName = UITextField()
  let createListButton = UIButton()

  weak var delegate: AddNewItemDelegate?

  var backgroundColor: UIColor? {
    get { return self.view.backgroundColor }
    set { self.view.backgroundColor = newValue }
  }

  var placeholder: String? {
    get { return self.newListName.placeholder }
    set { self.newListName.placeholder = newValue }
  }

  init() {
    super.init(nibName: nil, bundle: nil)

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

  func updateUI(_ newListState: NewNameState) {

    self.createListButton.isEnabled = newListState.addItemButtonEnabled
    if self.newListName.text != newListState.newName {
      self.newListName.text = newListState.newName
    }
  }

  func onAddList() {
    guard let newName = self.newListName.text,
          !newName.isEmpty else  { return }

    self.delegate?.onAddNewItem(name: newName)
  }

  func onNameChanged() {
    guard let newName = self.newListName.text else { return }

    self.delegate?.onItemNameChanged(newName: newName)
  }
}