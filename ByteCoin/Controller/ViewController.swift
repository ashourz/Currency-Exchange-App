//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
//MARK: - UIPickerVewDelegate
extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArray[row]
        print("Currency Selected: \(currency)")
        coinManager.getCoinPrice(for: currency)
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate{
    func didUpdatePrice(_ manager: CoinManager, rate: CoinRate) {
        DispatchQueue.main.async {
            self.currencyLabel.text = rate.currencyType
            self.bitcoinLabel.text = rate.rate
        }
    }
    
    func didFailWithError(error: any Error) {
        print(error)
    }
    
    
}
