//
//  ViewController.swift
//  Swift版
//
//  Created by jjs on 2017/12/14.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

import UIKit

struct Coll {
    let raw:Int
    
    static let bottom = Coll(raw: 1);
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var s:Int = Coll.bottom;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

