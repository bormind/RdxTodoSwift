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


final class ListCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
  RdxViewController {


  let disposableBag = DisposeBag()

  let newNameVC = NewListNameViewController()

  let tableView = UITableView()

  var sortedLists: [TodoList] = []

  init() {
    super.init(nibName: nil, bundle: nil)

    self.title = "Todo Lists"

    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = UIColor.white

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

  func setupStore(_ store: Store) {
    store
      .state
      .map { $0.listCollection }
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] state in self.updateUI(state) })
      .addDisposableTo(disposableBag)

    newNameVC.setupStore(store)
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

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sortedLists.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCellId, for: indexPath) as! TodoListCell
    cell.selectionStyle = .none
    cell.todoList = self.sortedLists[indexPath.row]
    return cell
  }

  private func updateUI(_ state: ListCollectionState) {
    self.sortedLists = state.sortedLists()
    self.tableView.reloadData()
  }
}
