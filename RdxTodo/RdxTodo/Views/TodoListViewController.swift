//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit
import StackViews
import RxSwift

fileprivate let TodoCellId = "TodoCellId"

fileprivate func isVisible(_ filterOption: FilterOptions)
    -> (TodoItem)
    -> Bool {

    return { todoItem in
        switch filterOption {
            case .showAll:
                return true
            case .showCompleted:
                return todoItem.isCompleted
            case .showActive:
                return !todoItem.isCompleted
        }
    }
}

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let disposableBag = DisposeBag()

    var todoItems: [TodoItem] = []

    let tableView = UITableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.automaticallyAdjustsScrollViewInsets = false

//        self.view.addSubview(self.tableView)
//        insetView(self.tableView, container: self.view, insets: Insets.zero)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(TodoItemCell.self, forCellReuseIdentifier: TodoCellId)

        self.view.backgroundColor = UIColor.black

        self.todoItems = gStore.state.todoList

        gStore
                .changedSubstate({ ($0.todoList, $0.filterOption) }, { $0.0 != $1.0 || $0.1 != $1.1 } )
                .subscribe(onNext: { [unowned self] in self.updateUI($0.0, $0.1) })
                .addDisposableTo(disposableBag)

        updateUI(gStore.state.todoList, gStore.state.filterOption)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoCellId, for: indexPath) as! TodoItemCell
        cell.selectionStyle = .none
        cell.todoItem = todoItems[indexPath.row]
        return cell
    }

    private func updateUI(_ todoItems: [TodoItem], _ filterOptions: FilterOptions) {
        self.todoItems = todoItems.filter(isVisible(filterOptions))
        self.tableView.reloadData()
    }
    
    
}
