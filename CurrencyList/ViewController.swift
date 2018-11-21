//
//  ViewController.swift
//  CurrencyList
//
//  Created by Gamze on 11/20/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var viewModel: CurrencyViewModel = {
        return CurrencyViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModel.showDataClosure = { [weak self] () in
            DispatchQueue.main.async {
                print(self!.viewModel.rateList)
            }
        }
    }
}
