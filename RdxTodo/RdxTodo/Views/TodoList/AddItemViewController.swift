//
// Created by Boris Schneiderman on 2017-05-05.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit
import StackViews

final class AddItemViewController: UIViewController, RdxViewController {

  let label = UILabel()
  let textField = UITextField()
  let addButton = UIButton()

  init() {
    super.init(nibName: nil, bundle: nil)

    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = UIColor.white

    self.label.text = "New ToDo:"
    self.addButton.setTitle("Add", for: .normal)

    _ = stackViews(
      container: self.view,
      orientation: .horizontal,
      justify: .fill,
      align: .center,
      insets: Insets(horizontal: 5),
      spacing: 0,
      views: [label, textField, addButton],
      widths: [30, nil, 30])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupStore(_ store: Store) {

  }
}
