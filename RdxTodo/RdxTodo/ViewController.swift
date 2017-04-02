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

class ViewController: UIViewController {

    let label1 = UILabel()
    let label2 = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        label1.text = "Boooooo"
        label2.text = "Fooooo"
        
        _ = stackViews(
            container: self.view,
            orientation: .vertical,
            justify: .center,
            align: .center,
            views: [label1, label2])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

