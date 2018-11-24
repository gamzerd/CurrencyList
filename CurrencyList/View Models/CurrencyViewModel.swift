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
    
    var showDataClosure: (()->())?
    var baseRate = Rate(id: "GBP", value: 1.0)
    
    func fetchPageData() {
        
        Foundation.Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fetchRates), userInfo: nil, repeats: true)
    }
    
    @objc private func fetchRates() {
        
        RevolutDataSource().getRates(base: self.baseRate.id, callback:
            { (data: CurrencyData?, error: Error?) -> Void in
                self.data = data
                self.rateList = (data?.rates.map { (arg) -> Rate in
                    let (key, value) = arg
                    return Rate(id: key, value: value * self.baseRate.value)
                    })!
                self.rateList.insert((self.baseRate), at: 0)
        })
    }
    
    func didSelectNewCurrency(index: Int) {
        
        self.baseRate = self.rateList[index]
        self.fetchRates()
    }
    
    func didChangeTextField(index: Int, valueOfSelectedItem: Float) {
        
        if (index == 0) {
            self.baseRate.value = valueOfSelectedItem
            self.invalidateList(exceptedCurrency: self.rateList[index].id)
            return
        }
        
        let idOfSelectedItem = self.rateList[index].id
        let originalValueOfSelectedItem = self.data?.rates[idOfSelectedItem]
        let newBaseValue = valueOfSelectedItem / originalValueOfSelectedItem!
        
        self.baseRate.value = newBaseValue
        self.rateList[index].value = valueOfSelectedItem
        self.invalidateList(exceptedCurrency: self.rateList[index].id)
    }
    
    func invalidateList(exceptedCurrency: String) {
        
        self.rateList = self.rateList.map { (rate) in
            if (rate.id == self.baseRate.id || rate.id == exceptedCurrency) {
                return rate
            }
            
            let originalValueOfItem = self.data?.rates[rate.id]
            let calculatedValue = originalValueOfItem! * self.baseRate.value
            return Rate(id: rate.id, value: calculatedValue)
        }
    }
}
