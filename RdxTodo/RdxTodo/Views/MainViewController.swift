//
//  ViewController.swift
//  RdxTodo
//
//  Created by Boris Schneiderman on 2017-04-02.
//  Copyright © 2017 bormind. All rights reserved.
//

import UIKit
import StackViews
import RxSwift

fileprivate func filterTitle(_ filterOption: FilterOptions) -> String {
    switch filterOption {
    case .showAll: return "All"
    case .showActive: return "Active"
    case .showCompleted: return "Completed"
    }
}

fileprivate func getMainSubstate(_ state: State) -> ([TodoItem], FilterOptions) {
    return (state.todoList, state.filterOption)
}

class MainViewController: UIViewController {

    let disposeBag = DisposeBag()
    let segmentCtrl = UISegmentedControl(items: FilterOptions.all.map(filterTitle))
    let todoListViewController = TodoListViewController()

    init() {
        super.init(nibName: nil, bundle: nil)

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white

        segmentCtrl.addTarget(self, action: #selector(filterSelected), for: .valueChanged)

        renderControls()

        gStore
                .changedSubstate({ $0.filterOption }, { $0 != $1 })
                .subscribe(onNext:{ [unowned self] in self.updateUI($0) })
                .addDisposableTo(disposeBag)

        updateUI(gStore.state.filterOption)

    }

    private func renderControls() {
        let rootView = stackViews(
                orientation: .vertical,
                justify: .fill,
                align: .fill,
                insets: Insets(horizontal: 10),
                spacing: 3,
                views: [segmentCtrl, todoListViewController.tableView],
                heights: [25, nil]).container

        _ = constrainToGuides(rootView, inViewController: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filterSelected() {
        gStore.dispatch(action: .setFilter(FilterOptions.all[segmentCtrl.selectedSegmentIndex]))
    }

    private func updateUI(_ filterOption: FilterOptions) {
        segmentCtrl.selectedSegmentIndex = FilterOptions.all.index(of:  filterOption) ?? 0
    }

}

