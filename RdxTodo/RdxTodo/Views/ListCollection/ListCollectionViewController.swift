//
// Created by Boris Schneiderman on 2017-05-09.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit
import StackViews
import RxSwift

fileprivate let ListCollectionSectionHeaderCellId = "ListCollectionSectionHeaderCellId"
fileprivate let TodoListCellId = "TodoListCellId"


final class ListCollectionViewController:
  UIViewController,
  UITableViewDataSource,
  UITableViewDelegate,
  AddNewItemDelegate,
  RdxViewController {

  var env: Environment?

  let disposableBag = DisposeBag()

  let newNameVC = NewItemNameViewController()

  let tableView = UITableView()

  var sortedLists: [TodoListState] = []

  init() {
    super.init(nibName: nil, bundle: nil)

    self.title = "Todo Lists"

    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = UIColor.white

    self.newNameVC.backgroundColor = UIColor.rgb(218, 226, 242)
    self.newNameVC.placeholder = "New list name"
    self.newNameVC.delegate = self

    self.tableView.dataSource = self
    self.tableView.delegate = self

    self.tableView.register(
      ListCollectionSectionHeaderCell.self,
      forCellReuseIdentifier: ListCollectionSectionHeaderCellId)

    self.tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCellId)

    _ = stackViews(
      container: self.view,
      orientation: .vertical,
      justify: .fill,
      align: .fill,
      insets: Insets(top: 64, left: 0, bottom: 0, right: 0),
      views: [newNameVC.view, tableView],
      heights: [35, nil])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(_ env: Environment) {

    self.env = env

    self.env?.store
      .state
      .map { $0.listCollection }
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] state in self.updateUI(state) })
      .addDisposableTo(disposableBag)

    self.env?.store
      .state
      .map { $0.newListNameState }
      .distinctUntilChanged()
      .subscribe(onNext: self.newNameVC.updateUI)
      .addDisposableTo(disposableBag)
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 44
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: ListCollectionSectionHeaderCellId) as! ListCollectionSectionHeaderCell

    if let env = self.env {
      cell.setup(env)
    }

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sortedLists.count
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let env = self.env else { return }

    let selectedList = self.sortedLists[indexPath.row]
    env.store.dispatch(.selectList(selectedList.listId))
    if selectedList.needsRefreshing {
      env.fetcher.fetchListDetails(listId: selectedList.listId)
    }

    let vc = TodoListViewController()
    vc.setup(env)

    self.navigationController?.pushViewController(vc, animated: true)
  }

  func onAddNewItem(name: String) {
    let newTodoList = TodoList(name: name)
    self.env?.store.dispatch(.listCollectionAction(.addOrUpdateTodoList(newTodoList)))
    self.env?.store.dispatch(.newListNameAction(.clearNewItemName))
  }

  func onItemNameChanged(newName: String) {
    self.env?.store.dispatch(.newListNameAction(.setNewItemName(newName)))
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCellId, for: indexPath) as! TodoListCell
    cell.accessoryType = .disclosureIndicator
    cell.selectionStyle = .none
    cell.todoList = self.sortedLists[indexPath.row].list
    return cell
  }

  private func updateUI(_ state: ListCollectionState) {
    self.sortedLists = state.sortedLists()
    self.tableView.reloadData()
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }

    let selectedList = self.sortedLists[indexPath.row]

    self.env?.store.dispatch(.listCollectionAction(.removeTodoList(selectedList.listId)))
  }
}
