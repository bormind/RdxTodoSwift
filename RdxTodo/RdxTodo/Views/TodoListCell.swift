//
// Created by Boris Schneiderman on 2017-05-09.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit
import StackViews

class TodoListCell: UITableViewCell {


  let listNameLabel = UILabel()
  let lastWatchedTimeLabel = UILabel()
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
    self.lastWatchedTimeLabel.textAlignment = .center

    _ = stackViews(
      container: self.contentView,
      orientation: .horizontal,
      justify: .fill,
      align: .center,
      views: [listNameLabel, lastWatchedTimeLabel],
      widths: [nil, 40])

    updateUI(self.todoList)
  }

  private func updateUI(_ todoList: TodoList?) {
    if let todoList = todoList {
      lastWatchedTimeLabel.text = dateFormatter.string(from: todoList.lastWatched)
    } else {
      lastWatchedTimeLabel.text = "Last Watched"
    }

    listNameLabel.text = todoList?.name ?? "List Name"
  }
}


