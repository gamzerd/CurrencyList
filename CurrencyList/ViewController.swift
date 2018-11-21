//
//  ViewController.swift
//  CurrencyList
//
//  Created by Gamze on 11/20/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RevolutDataSource().getRates(base: "TRY", callback:
            { (data: CurrencyData?, error: Error?) -> Void in
                print("VC")
                print(data?.rates as Any)
        })
        
    }


}

