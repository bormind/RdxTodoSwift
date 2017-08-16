//
// Created by Boris Schneiderman on 7/24/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit

enum HorizontalAlignment {
  case left
  case center
  case right
}

struct Styling {
  static let titleButtonAttributesSorted: [String: Any] = [
    NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
    NSForegroundColorAttributeName: UIColor.blue,
    NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]

  static let titleButtonAttributesNonSorted: [String: Any] = [
    NSFontAttributeName: UIFont.systemFont(ofSize: 14),
    NSForegroundColorAttributeName: UIColor.blue,
    NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue]
}

