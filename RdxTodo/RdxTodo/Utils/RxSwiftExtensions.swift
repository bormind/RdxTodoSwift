//
// Created by Boris Schneiderman on 2017-04-05.
// Copyright (c) 2017 bormind. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {

    func pairWithPrevious() -> Observable<(E, E)> {
        return self.scan([]) { arr, newVal in
                    if arr.count == 0 {
                        return [newVal]
                    }
                    else {
                        return [arr[arr.count - 1], newVal]
                    }
                }
                .skipWhile { $0.count != 2 }
                .map { ($0[0], $0[1])}
    }


}




