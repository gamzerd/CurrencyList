//
//  CurrencyViewModelImpl.swift
//  CurrencyList
//
//  Created by Gamze on 11/21/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

class CurrencyViewModelImpl: CurrencyViewModel {
    
    // data source that the rate data is fetched
    var dataSource: DataSource = RevolutDataSource()
    
    var timer: Timer?
    
    // the value of the base rate is always 1
    let originalValueOfTheBaseRate: Float = 1.0
    
    var baseRate = Rate(id: "GBP", value: 1.0)
    
    // response that will be received from the API
    var data: CurrencyData?
    
    var error: Error? {
        didSet {
            self.showErrorClosure?()
        }
    }
    
    var showErrorClosure: (() -> ())?
    
    // list that will be used by the view
    var rateList: [Rate] = [] {
        didSet {
            self.showDataClosure?()
        }
    }
    
    var showDataClosure: (() -> ())?

    /**
     * Starts the periodic API call.
     */
    func fetchPageData() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fetchRates), userInfo: nil, repeats: true)
    }
    
    /**
     * Retrieves the rate list.
     */
    @objc private func fetchRates() {
        dataSource.getRates(base: self.baseRate.id, callback:self.didResponseReceive(data:error:))
    }
    
    /**
     * Called when the API response is received. Generates a new list from the
     * rates in the data and also adds the base rate to the head of the list.
     * @param data: the data of the response.
     * @param error: error if callback fails.
     */
    func didResponseReceive(data: CurrencyData?, error: Error?) {
        
        if (error != nil) {
            self.error = error
            return
        }
        
        self.data = data
        self.rateList = (data?.rates.map { (arg) -> Rate in
                let (key, value) = arg
                return Rate(id: key, value: value * self.baseRate.value)
            })!
        self.rateList.insert((self.baseRate), at: 0)
    }
    
    /**
     * Called when a row of the currency list is selected.
     * Updates the base rate value and fetches the rate list based on the new base.
     * @param index: index of the selected row.
     */
    func didSelectNewCurrency(index: Int) {
        self.baseRate = self.rateList[index]
        self.fetchRates()
    }
    
    /**
     * Called when input of a currency rate is changed.
     * Calculates the new base value and invalidates the list.
     * @param index: index of the changed currency.
     * @param valueOfChangedItem: new value of the changed currency.
     */
    func didChangeTextField(index: Int, valueOfChangedItem: Float) {
        
        let idOfChangedItem = self.rateList[index].id
        
        // set the new value of the base rate based on the given index and the value
        if (index == 0) {
            // set the value of the base rate
            self.baseRate.value = valueOfChangedItem
        } else {
            let originalValueOfChangedItem = self.data?.rates[idOfChangedItem]

            // calculate the new base value.
            self.baseRate.value = originalValueOfTheBaseRate * valueOfChangedItem / originalValueOfChangedItem!
        }
        
        // calculate the new values of all items in the list
        self.rateList = self.rateList.map { (rate) in
            
            if (rate.id == self.baseRate.id) {
                // new value of baseRate is already calculated above, return it here
                return self.baseRate
                
            } else if (rate.id == idOfChangedItem) {
                // use the parameter valueOfChangedItem as the new value of this rate
                return Rate(id: rate.id, value: valueOfChangedItem)
            }
            
            // get the unchanged value of the rate for calculation
            let originalValueOfItem = self.data?.rates[rate.id]
            
            // calculate the new value of the rate.
            let calculatedValue = originalValueOfItem! * self.baseRate.value / originalValueOfTheBaseRate
            return Rate(id: rate.id, value: calculatedValue)
        }
    }
    
    /**
     * Called when the view is closed. Clears the resources.
     */
    func reset() {
        self.timer?.invalidate()
    }
}
