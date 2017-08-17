//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit
import StackViews
import RxSwift


fileprivate let TodoItemCellId = "TodoItemCellId"


fileprivate func filterTitle(_ filterOption: FilterOptions) -> String {
  switch filterOption {
  case .showAll: return "All"
  case .showActive: return "Active"
  case .showCompleted: return "Completed"
  }
}

protocol TodoItemCellDelegate: class{
  func completeItem(_ itemId: ListItemId, isCompleted: Bool)
  func deleteItem(_ itemId: ListItemId)
}

class TodoListViewController:  UIViewController, RdxViewController,
  UITableViewDataSource,  UITableViewDelegate, TodoItemCellDelegate, AddNewItemDelegate {

  var env: Environment?

  let disposableBag = DisposeBag()

  let newItemNameVC = NewItemNameViewController()
  let segmentCtrl = UISegmentedControl(items: FilterOptions.all.map(filterTitle))

  let tableView = UITableView()

  var listId: ListId?
  var itemsToDisplay: [TodoItem] = []

  init() {
    super.init(nibName: nil, bundle: nil)
    self.automaticallyAdjustsScrollViewInsets = false

    self.view.backgroundColor = UIColor.white

    self.newItemNameVC.delegate = self
    self.newItemNameVC.placeholder = "New Entry"
    self.newItemNameVC.backgroundColor = UIColor.rgb(165, 251, 237)

    self.segmentCtrl.addTarget(self, action: #selector(filterSelected), for: .valueChanged)

    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(TodoItemCell.self, forCellReuseIdentifier: TodoItemCellId)

    renderControls()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  internal func setup(_ env: Environment) {
    self.env = env

    self.env?.store
      .state
      .map {  $0.selectedList  }
      .unwrap()
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] data in self.updateUI(data) })
      .addDisposableTo(disposableBag)

    self.env?.store
      .state
      .map { $0.newTodoItemState }
      .subscribe(onNext: self.newItemNameVC.updateUI)
      .addDisposableTo(disposableBag)
  }

  private func renderControls() {
    let tableWithFilter = stackViews(
      orientation: .vertical,
      justify: .fill,
      align: .fill,
      insets: Insets(horizontal: 3),
      spacing: 3,
      views: [segmentCtrl, tableView],
      heights: [25, nil]).container

    _ = stackViews(
      container: self.view,
      orientation: .vertical,
      justify: .fill,
      align: .fill,
      insets: Insets(top: 63, left: 0, bottom: 0, right: 0),
      spacing: 3,
      views: [newItemNameVC.view, tableWithFilter],
      heights: [35, nil])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsToDisplay.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemCellId, for: indexPath) as! TodoItemCell
    cell.delegate = self
    cell.selectionStyle = .none
    cell.todoItem = self.itemsToDisplay[indexPath.row]
    return cell
  }

  private func updateUI(_ state: TodoListState) {
    segmentCtrl.selectedSegmentIndex = FilterOptions.all.index(of: state.filterOption) ?? 0

    self.title = state.list.name
    self.listId = state.listId
    self.itemsToDisplay = state.visibleAndSortedItems()
    self.tableView.reloadData()
  }

  func filterSelected() {
    guard let listId = self.listId else { return }
    self.env?.store.dispatch(.todoListAction(listId, .setFilter(FilterOptions.all[segmentCtrl.selectedSegmentIndex])))
  }

  func completeItem(_ itemId: ListItemId, isCompleted: Bool) {
    guard let listId = self.listId else { return }
    self.env?.store.dispatch(.todoListAction(listId, .markAsCompleted(itemId, isCompleted)))
  }

  func deleteItem(_ itemId: ListItemId) {
    guard let listId = self.listId else { return }
    self.env?.store.dispatch(.todoListAction(listId, .removeItem(itemId)))
  }

  func onAddNewItem(name: String) {
    guard let listId = self.listId else { return }

    let newItem = TodoItem(id: ListItemId(), todoText: name)

    self.env?.store.dispatch(.todoListAction(listId, .addItem(newItem)))
    self.env?.store.dispatch(.newTodoItemAction(.clearNewItemName))
  }

  func onItemNameChanged(newName: String) {
    self.env?.store.dispatch(.newTodoItemAction(.setNewItemName(newName)))
  }
}
