//
// Created by Boris Schneiderman on 6/18/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  static func rgb(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
    return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
  }
}