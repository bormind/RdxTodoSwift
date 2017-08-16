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
  UITableViewDataSource,  UITableViewDelegate, TodoItemCellDelegate {

  var env: Environment?

  let disposableBag = DisposeBag()

  let segmentCtrl = UISegmentedControl(items: FilterOptions.all.map(filterTitle))

  let tableView = UITableView()

  var listId: ListId?
  var itemsToDisplay: [TodoItem] = []

  init() {
    super.init(nibName: nil, bundle: nil)
    self.automaticallyAdjustsScrollViewInsets = false

    segmentCtrl.addTarget(self, action: #selector(filterSelected), for: .valueChanged)

//        self.view.addSubview(self.tableView)
//        insetView(self.tableView, container: self.view, insets: Insets.zero)

    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(TodoItemCell.self, forCellReuseIdentifier: TodoItemCellId)

    self.view.backgroundColor = UIColor.black

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
  }

  private func renderControls() {
    let rootView = stackViews(
      orientation: .vertical,
      justify: .fill,
      align: .fill,
      insets: Insets(horizontal: 10),
      spacing: 3,
      views: [segmentCtrl, tableView],
      heights: [25, nil]).container

    _ = constrainToGuides(rootView, inViewController: self)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsToDisplay.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemCellId, for: indexPath) as! TodoItemCell
    cell.selectionStyle = .none
    cell.todoItem = self.itemsToDisplay[indexPath.row]
    return cell
  }

  private func updateUI(_ state: TodoListState) {
    segmentCtrl.selectedSegmentIndex = FilterOptions.all.index(of: state.filterOption) ?? 0

    self.title = state.list.name
    self.listId = state.listId
    self.itemsToDisplay = state.visibleItems()
    self.tableView.reloadData()
  }

  func filterSelected() {
    guard let listId = self.listId else { return }
    self.env?.store.dispatch(Action(listId, .setFilter(FilterOptions.all[segmentCtrl.selectedSegmentIndex])))
  }

  func completeItem(_ itemId: ListItemId, isCompleted: Bool) {
    guard let listId = self.listId else { return }
    self.env?.store.dispatch(Action(listId, .markAsCompleted(itemId, isCompleted)))
  }

  func deleteItem(_ itemId: ListItemId) {
    guard let listId = self.listId else { return }
    self.env?.store.dispatch(Action(listId, .removeItem(itemId)))
  }


}
