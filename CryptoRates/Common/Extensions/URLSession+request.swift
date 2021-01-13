//
//  URLSession+request.swift
//  CryptoRates
//
//  Created by Владимир Беляев on 13.01.2021.
//

import Foundation

extension URLSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func request(_ endpoint: Endpoint, then handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint.url, completionHandler: handler)
        task.resume()
        return task
    }
}
