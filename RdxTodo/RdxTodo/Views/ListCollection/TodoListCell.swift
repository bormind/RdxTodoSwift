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

    [listNameLabel, lastWatchedTimeLabel].enumerated().forEach {
      $1.alignContent(ListCollectionCellStyles.alignments[$0])
    }

    _ = stackViews(
      container: self.contentView,
      orientation: .horizontal,
      justify: .fill,
      align: .center,
      insets: Insets(
        top: 0,
        left: ListCollectionCellStyles.headerMarginLeft,
        bottom: 0,
        right: ListCollectionCellStyles.headerMarginRight),
      views: [listNameLabel, lastWatchedTimeLabel],
      widths: ListCollectionCellStyles.widths)

    updateUI(self.todoList)
  }

  private func updateUI(_ todoList: TodoList?) {
    if let todoList = todoList {
      lastWatchedTimeLabel.text = dateFormatter.string(from: todoList.lastModified)
    } else {
      lastWatchedTimeLabel.text = "Last Watched"
    }

    listNameLabel.text = todoList?.name ?? "List Name"
  }
}


