//
// Created by Boris Schneiderman on 2017-04-04.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation

enum FilterOptions {
    case showAll, showActive, showCompleted

    static var all: [FilterOptions] {
        return [.showAll, .showActive, .showCompleted]
    }
}


