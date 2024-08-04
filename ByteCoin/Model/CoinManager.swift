//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdatePrice(_ manager: CoinManager, rate: CoinRate)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate? = nil
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F84F3347-A2A3-45E5-A9B4-D2A5DE10E55D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func currencyExtension(_ currency: String) -> String {
        return "/\(currency)"
    }
    
    var apiExtension: String{
        return "?apikey=\(apiKey)"
    }
    func getCoinPrice(for currency: String){
        let url = baseURL+currencyExtension(currency)+apiExtension
        
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coinData = self.parseJSON(safeData){
                        let rateString = String(format: "%.2f", coinData.rate)
                        let coinRate = CoinRate(currencyType: coinData.asset_id_quote, rate: rateString)
                        self.delegate?.didUpdatePrice(self, rate: coinRate)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do{
            let coinData = try decoder.decode(CoinData.self, from: data)
            print(coinData)
            return coinData
        } catch {
            self.delegate?.didFailWithError(error: error)

        }
        return nil
    }
}
