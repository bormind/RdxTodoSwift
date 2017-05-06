

import Foundation
import UIKit
import StackViews
import FontAwesome

class TodoItemCell: UITableViewCell {


    let completedButton = UIButton()
    let deleteButton = UIButton()
    let label = UILabel()

    var todoItem: TodoItem? {
        didSet {
            updateUI(self.todoItem)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        completedButton.setTitleColor(UIColor.black, for: .normal)
        deleteButton.setTitleColor(UIColor.red, for: .normal)
        deleteButton.setTitle(String.fontAwesomeIcon(code: "fa-times-circle")!, for: .normal)

        completedButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 15)
        completedButton.addTarget(self, action: #selector(onCompleteTodoItem), for: .touchUpInside)
        deleteButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 15)
        deleteButton.addTarget(self, action: #selector(onDeleteItem), for: .touchUpInside)
        arrangeControls()


    }

    private func arrangeControls() {
        stackViews(container: self.contentView,
                orientation: .horizontal,
                justify: .fill,
                align: .fill,
                spacing: 10,
                views: [completedButton, label, deleteButton],
                widths: [20, nil, 20])

    }

    func onCompleteTodoItem() {
        if let item = todoItem {
            gStore.dispatch(action: .markAsCompleted(item.id, !item.isCompleted))
        }
    }

    func onDeleteItem() {
        if let item = todoItem {
            gStore.dispatch(action: .removeItem(item.id))
        }
    }

    private func updateUI(_ todoItem: TodoItem?) {
        guard let todoItem = todoItem else {
            self.label.text = ""
            self.completedButton.setTitle("", for: .normal)
            self.deleteButton.setTitle("", for: .normal)
            return
        }

        let checkBoxFontName: String
        if todoItem.isCompleted {
            checkBoxFontName = "fa-check-square-o"
            let attributedString = NSMutableAttributedString(string: todoItem.todoText)
            attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributedString.length))
            self.label.attributedText = attributedString
            self.label.textColor = UIColor.lightGray
        }
        else {
            checkBoxFontName = "fa-square-o"
            self.label.text = todoItem.todoText
            self.label.textColor = UIColor.black
        }

        // fa-angle-down "fa-check-square-o" : "fa-square-o" fa-times-circle"
        self.completedButton.setTitle(String.fontAwesomeIcon(code: checkBoxFontName)!, for: .normal)
    }

}