//
//  CurrencyListTableViewController.swift
//  CurrencyList
//
//  Created by Gamze on 11/20/18.
//  Copyright © 2018 gamzerd. All rights reserved.
//

import UIKit

class CurrencyListTableViewController: UITableViewController {
    
    lazy var viewModel: CurrencyViewModel = {
        return CurrencyViewModelImpl()
    }()
    
    var cellDictionary: [String:UITableViewCell] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.showDataClosure = { [weak self] () in
            DispatchQueue.main.async {
                self!.showData()
            }
        }
        
        viewModel.showErrorClosure = { [weak self] () in
            DispatchQueue.main.async {
                self!.showAlertMessage()
            }
        }
        
        viewModel.fetchPageData()
    }
    
    /**
     * Called when the rate list is updated.
     */
    func showData() {
        if self.cellDictionary.isEmpty {
            self.reloadTableViewAndFocusToFirstRow()
        } else {
            self.updateValuesOfCells()
        }
    }
    
    /**
     * Called when view model has an error.
     */
    func showAlertMessage() {
        let alert = UIAlertController(title: "Error", message: "Rate list couldn't be fetched!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     * Reloads the table view, scrolls to the first
     * row and focuses on the text field of the first cell.
     */
    func reloadTableViewAndFocusToFirstRow() {
        // reload the tableView and scroll to top
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        // focus to the first input and open the keyboard, wait for render to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let cell = self.cellDictionary[self.viewModel.baseRate.id]
            if cell != nil {
                (cell as! CurrencyListTableViewCell).currencyRateTextField.becomeFirstResponder()
            }
        }
    }
    
    /**
     * Iterates over the cell list and updates the text
     * field values based on the corresponding rate value in the list.
     */
    func updateValuesOfCells() {
        // update the values of text field of each cell reference
        for rate in (self.viewModel.rateList) {
            
            if self.cellDictionary[rate.id] == nil {
                // skip the rate if it is not shown on the UI
                continue
            }
            let cell = self.cellDictionary[rate.id] as! CurrencyListTableViewCell
            cell.currencyRateTextField.text = self.getCurrencyWithFormat(comingAmount: rate.value)
        }
    }
    
    /**
     * Formats the given number and returns a string representation of it.
     * @param comingAmount: Number to format.
     * @return formatted string.
     */
    func getCurrencyWithFormat (comingAmount : Float) -> String{
        if (comingAmount == 0) {
            return ""
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencyDecimalSeparator = "."
        formatter.currencyGroupingSeparator = ""
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        let balance = formatter.string(from: NSNumber(value: comingAmount))
        return balance!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rateList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyListTVCid") as! CurrencyListTableViewCell
        let rate = self.viewModel.rateList[indexPath.row]
        
        cell.currencyNameLabel.text = rate.id
        cell.currencyRateTextField.text = getCurrencyWithFormat(comingAmount: rate.value)
        cell.currencyRateTextField.tag = indexPath.row
        cell.currencyRateTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.cellDictionary[rate.id] = cell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        self.cellDictionary = [:]
        self.viewModel.didSelectNewCurrency(index: indexPath.row)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let txt = textField.text {
            let value = try? Float(txt)

            self.viewModel.didChangeTextField(index: textField.tag, valueOfChangedItem: value! ?? 0)
        }
    }
    
    deinit {
        self.viewModel.reset()
    }
    
}
