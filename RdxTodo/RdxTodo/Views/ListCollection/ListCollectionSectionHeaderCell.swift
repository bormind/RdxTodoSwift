//
//  ListCollectionSectionHeaderCell.swift
//  RdxTodo
//
//  Created by Boris Schneiderman on 7/11/17.
//  Copyright © 2017 bormind. All rights reserved.
//

import Foundation
import UIKit
import StackViews
import RxSwift

fileprivate typealias ButtonAttributes = (UIButton, String, ListsSorting)

class ListCollectionSectionHeaderCell: UITableViewCell, RdxViewController {

  let disposableBag = DisposeBag()

  let listName = UIButton()
  let modifiedDate = UIButton()
  var store: Store?

  fileprivate var buttonAttributes: [ButtonAttributes]!

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)


    self.buttonAttributes = [
      (self.listName, "List Name", .byName),
      (self.modifiedDate, "Modified", .byLastModified)
    ]

    buttonAttributes
      .map { $0.0 }
      .enumerated()
      .forEach {
        $1.alignContent(ListCollectionCellStyles.alignments[$0])
        $1.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
      }

    _ = stackViews(
      container: self.contentView,
      orientation: .horizontal,
      justify: .fill,
      align: .fill,
      insets: Insets(
        top: 0,
        left: ListCollectionCellStyles.headerMarginLeft,
        bottom: 0,
        right: ListCollectionCellStyles.headerMarginRight),
      views:[self.listName, self.modifiedDate],
      widths: ListCollectionCellStyles.widths)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupStore(_ store: Store) {
    self.store = store

    self.store?
      .state
      .map { $0.listCollection.sortBy }
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] sortBy in self.updateUI(sortBy) })
      .addDisposableTo(disposableBag)
  }

  private func updateUI(_ sortBy: ListsSorting) {
    buttonAttributes.forEach { buttonAttributes in
      let attributedString = NSMutableAttributedString(
        string: buttonAttributes.1,
        attributes: buttonAttributes.2 == sortBy
          ? Styling.titleButtonAttributesSorted
          : Styling.titleButtonAttributesNonSorted
        )

      buttonAttributes.0.setAttributedTitle(attributedString, for: .normal)
    }
  }

  func onButtonClick(button: UIButton) {
    guard let buttonAttr = self.buttonAttributes.first(where: { $0.0 == button }) else {
      return
    }

    self.store?.dispatch(Action(.setListSort(buttonAttr.2)))
  }

}
