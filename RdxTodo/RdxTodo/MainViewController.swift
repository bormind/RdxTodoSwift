//
//  ViewController.swift
//  RdxTodo
//
//  Created by Boris Schneiderman on 2017-04-02.
//  Copyright © 2017 bormind. All rights reserved.
//

import UIKit
import StackViews
import RxSwift

class MainViewController: UIViewController {

    let label1 = UILabel()
    let label2 = UILabel()

    init() {
        super.init(nibName: nil, bundle: nil)

        self.automaticallyAdjustsScrollViewInsets = false

        self.view.backgroundColor = UIColor.white

        label1.text = "Boooooo"
        label2.text = "Fooooo"

        _ = stackViews(
                container: self.view,
                orientation: .vertical,
                justify: .center,
                align: .center,
                views: [label1, label2])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

