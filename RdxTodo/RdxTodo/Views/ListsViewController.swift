//
// Created by Boris Schneiderman on 2017-05-09.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit
import StackViews
import RxSwift

fileprivate let TodoListCellId = "TodoListCellId"

fileprivate typealias Substate = (lists: [TodoList], sortBy: TodoListsSorting)

fileprivate func substate(_ state: State) -> Substate {
    return (lists: state.lists, sortBy: state.sortBy)
}

class ListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let disposableBag = DisposeBag()

    let tableView = UITableView()
    let newListLabel = UILabel()
    let newListName = UITextField()
    let createListButton = UIButton()

    var sortedLists: [TodoList] = []

    init() {
        super.init(nibName: nil, bundle: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.register(TodoItemCell.self, forCellReuseIdentifier: TodoListCellId)

        self.renderControls()

        gStore
                .changedSubstate(substate, { $0 != $1 })
                .subscribe(onNext: { [unowned self] (s: Substate) in self.updateUI(s) })
                .addDisposableTo(disposableBag)

        self.updateUI(substate(gStore.state))

    }

    private func renderControls() {

        let newListRow = stackViews(
                orientation: .horizontal,
                justify: .fill,
                align: .center,
                insets: Insets(horizontal: 5),
                spacing: 2,
                views: [newListLabel, newListName, createListButton],
                widths: [30, nil, 40]).container

        _ = stackViews(
                orientation: .vertical,
                justify: .fill,
                align: .fill,
                insets: Insets(horizontal: 5),
                spacing: 5,
                views: [newListRow, tableView],
                heights: [30, nil])

    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
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

    private func updateUI(_ substate: Substate) {

        let compareDates: (TodoList, TodoList) -> Bool = { $0.created <= $1.created }
        let compareNames: (TodoList, TodoList) -> Bool = { $0.name <= $1.name }

        self.sortedLists = substate.lists.sorted(by: substate.sortBy == .byDate ? compareDates : compareNames)

        self.tableView.reloadData()
    }
}
