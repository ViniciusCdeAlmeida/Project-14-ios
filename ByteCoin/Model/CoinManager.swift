//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ CoinManager: CoinManager, coin: CoinData)
    func didFailError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "467A3077-C816-42F3-9CFE-9734290AA081"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) -> Double {
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        self.dataRequest(url: urlString)
        return 0.0
    }
    
    func dataRequest(url: String){
        if let initialUrl = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: initialUrl) { data, response, error in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJson(coin: safeData) {
                        self.delegate?.didUpdateCurrency(self, coin: coin)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func parseJson(coin: Data)-> CoinData? {
        let decoder = JSONDecoder()
        do {
            
          let decodedData = try decoder.decode(CoinData.self, from: coin)
           
            let rate = decodedData.rate
            
            let currentCurrency = CoinData(rate: rate)
            print(currentCurrency.rate)
            return currentCurrency
        } catch{
            delegate?.didFailError(error: error)
            return nil
        }
    }
}
