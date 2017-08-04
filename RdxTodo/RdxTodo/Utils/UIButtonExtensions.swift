//
// Created by Boris Schneiderman on 7/24/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  func alignContent(_ alignment: HorizontalAlignment) {
    switch alignment {
      case .left: self.contentHorizontalAlignment = .left
      case .center: self.contentHorizontalAlignment = .center
      case .right: self.contentHorizontalAlignment = .right
    }
  }
}