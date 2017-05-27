//
// Created by Boris Schneiderman on 2017-05-09.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit
import StackViews

class TodoListCell: UITableViewCell {


    let listNameLabel = UILabel()
    let createdTimeLabel = UILabel()
    let dateFormatter = DateFormatter()

    var todoList: TodoList? {
        didSet {
            updateUI(self.todoList)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.dateFormatter.dateFormat = "MMM d, h:mm a"
        self.createdTimeLabel.textAlignment = .center

        _ = stackViews(
            container: self.contentView,
            orientation: .horizontal,
            justify: .fill,
            align: .center,
            views: [listNameLabel, createdTimeLabel],
            widths:[nil, 40])
    
        updateUI(self.todoList)
    }
    
    private func updateUI(_ todoList: TodoList?) {
        if let todoList = todoList {
            listNameLabel.text = todoList.name
            createdTimeLabel.text = dateFormatter.string(from: todoList.created)
        }
        else {
            listNameLabel.text = "List Name"
            createdTimeLabel.text = "Created"
        }
    }
}


