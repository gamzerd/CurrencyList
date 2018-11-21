//
//  CurrencyViewModel.swift
//  CurrencyList
//
//  Created by Gamze on 11/21/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

class CurrencyViewModel {
    
    private var data: CurrencyData?
    
    var rateList: [Rate] = [] {
        didSet {
            self.showDataClosure?()
        }
    }
    
    var base: String = "GBP"
    var showDataClosure: (()->())?
    
    init() {

        RevolutDataSource().getRates(base: base, callback:
            { (data: CurrencyData?, error: Error?) -> Void in
                self.data = data
                
                self.rateList = (data?.rates.map { (arg) -> Rate in
                    
                    let (key, value) = arg
                    return Rate(id: key, value: value)
                    })!
        })
    }
    
}
