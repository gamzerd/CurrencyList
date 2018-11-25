//
//  CurrencyViewModel.swift
//  CurrencyList
//
//  Created by Gamze on 11/25/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import Foundation

protocol CurrencyViewModel {
    
    // called when the list is changed
    var showDataClosure: (()->())? { get set }
    
    // called when the list has an error
    var showErrorClosure: (()->())? { get set }
    
    // keeps the base rate info
    var baseRate: Rate { get set }
    
    // generated list that will be used by the view
    var rateList: [Rate] { get }
    
    func fetchPageData()
    
    /**
     * Called when a row of the currency list is selected.
     * @param index: index of the selected row.
     */
    func didSelectNewCurrency(index: Int)
    
    /**
     * Called when input of a currency rate is changed.
     * @param index: index of the changed currency.
     * @param valueOfChangedItem: new value of the changed currency.
     */
    func didChangeTextField(index: Int, valueOfChangedItem: Float)
    
    /**
     * Called when the view is closed.
     */
    func reset()
}
