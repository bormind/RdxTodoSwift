//
// Created by Boris Schneiderman on 7/24/17.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  func alignContent(_ alignment: HorizontalAlignment) {
    switch alignment {
    case .left: self.textAlignment = .left
    case .center: self.textAlignment = .center
    case .right: self.textAlignment = .right
    }
  }
}