//
//  URL+endpoints.swift
//  CryptoRates
//
//  Created by Владимир Беляев on 13.01.2021.
//

import Foundation

extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api.coingecko.com/api/v3/\(endpoint)")!
    }
}
