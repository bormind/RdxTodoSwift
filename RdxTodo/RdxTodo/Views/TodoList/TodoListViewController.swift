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

  var selectedList: TodoListState?
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
      .map { $0.newTodoItemNameState
      }
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
    guard let selectedList = self.selectedList else { return 0 }

    if selectedList.isFetchingListData || selectedList.fetchingError != nil {
      return 1
    }
    else {
      return itemsToDisplay.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let selectedList = self.selectedList else { return UITableViewCell() }

    if selectedList.isFetchingListData {
      let cell = UITableViewCell()
      cell.textLabel?.text = "Fetching list data..."
      return cell
    }

    if let error = selectedList.fetchingError {
      let cell = UITableViewCell()
      cell.textLabel?.text = error
      return cell
    }

    let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemCellId, for: indexPath) as! TodoItemCell
    cell.delegate = self
    cell.selectionStyle = .none
    cell.todoItem = self.itemsToDisplay[indexPath.row]
    return cell
  }

  private func updateUI(_ state: TodoListState) {
    self.selectedList = state

    segmentCtrl.selectedSegmentIndex = FilterOptions.all.index(of: state.filterOption) ?? 0

    self.title = state.list.name
    self.itemsToDisplay = state.visibleAndSortedItems()
    self.tableView.reloadData()
  }

  func filterSelected() {
    guard let listId = self.selectedList?.listId else { return }
    self.env?.store.dispatch(.todoListAction(listId, .setFilter(FilterOptions.all[segmentCtrl.selectedSegmentIndex])))
  }

  func completeItem(_ itemId: ListItemId, isCompleted: Bool) {
    guard let listId = self.selectedList?.listId else { return }
    self.env?.store.dispatch(.todoListAction(listId, .markAsCompleted(itemId, isCompleted)))
  }

  func deleteItem(_ itemId: ListItemId) {
    guard let listId = self.selectedList?.listId else { return }
    self.env?.store.dispatch(.todoListAction(listId, .removeItem(itemId)))
  }

  func onAddNewItem(name: String) {
    guard let listId = self.selectedList?.listId else { return }

    let newItem = TodoItem(id: ListItemId(), todoText: name)

    self.env?.store.dispatch(.todoListAction(listId, .addItem(newItem)))
    self.env?.store.dispatch(.newTodoItemAction(.clearNewItemName))
  }

  func onItemNameChanged(newName: String) {
    self.env?.store.dispatch(.newTodoItemAction(.setNewItemName(newName)))
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard let listId = self.selectedList?.listId,
          editingStyle == .delete else { return }

    let item = itemsToDisplay[indexPath.row]
    self.env?.store.dispatch(.todoListAction(listId, .removeItem(item.id)))
  }
}
