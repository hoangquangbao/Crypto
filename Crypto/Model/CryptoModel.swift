//
//  CryptoModel.swift
//  Crypto
//
//  Created by Quang Bao on 19/04/2022.
//

import SwiftUI

// MARK: Crypto Model For JSON Fetching

// MARK: - WelcomeElement
struct CryptoModel: Identifiable, Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let lastUpdated: String
    let last7DaysPrice: GraphModel
    let priceChange: Double

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case lastUpdated = "last_updated"
        case last7DaysPrice = "sparkline_in_7d"
        case priceChange = "price_change_percentage_24h_in_currency"
    }
}

// MARK: - SparklineIn7D
struct GraphModel: Codable {
    let price: [Double]
    
    enum CodingKeys: String, CodingKey {
        case price
    }
}

// MARK: - JSON URL
let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&sparkline=true&price_change_percentage=24h")
