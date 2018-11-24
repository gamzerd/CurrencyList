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
        return CurrencyViewModel()
    }()
    
    var cellDictionary: [String:UITableViewCell] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.showDataClosure = { [weak self] () in
            DispatchQueue.main.async {
                if self!.cellDictionary.isEmpty {
                    self!.tableView.reloadData()
                    let topIndex = IndexPath(row: 0, section: 0)
                    self?.tableView.scrollToRow(at: topIndex, at: .top, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        let cell = self!.cellDictionary[self!.viewModel.baseRate.id]
                        if cell != nil {
                            (cell as! CurrencyListTableViewCell).currencyRateTextField.becomeFirstResponder()
                        }
                    }
                    
                } else {
                    for rate in (self?.viewModel.rateList)! {
                        
                        if self!.cellDictionary[rate.id] == nil {
                            continue
                        }
                        let cell = self!.cellDictionary[rate.id] as! CurrencyListTableViewCell
                        cell.currencyRateTextField.text = self!.getCurrencyWithFormat(comingAmount: rate.value)
                    }
                }
            }
        }
        
        viewModel.fetchPageData()
    }
    
    func getCurrencyWithFormat (comingAmount : Float) -> String{
        if (comingAmount == 0) {
            return ""
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.negativePrefix = "-"
        formatter.negativeSuffix = ""
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
        
        textField.becomeFirstResponder()
        if let txt = textField.text {
            let value = try? Float(txt)

            self.viewModel.didChangeTextField(index: textField.tag, valueOfSelectedItem: value! ?? 0)
        }
    }
    
}
