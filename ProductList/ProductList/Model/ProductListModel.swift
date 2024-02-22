//
//  ProductListModel.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import Foundation

struct ProductListModel: Codable {
    var products: [Product]?
    var total, skip, limit: Int?
}

struct Product: Codable {
    var id: Int?
    var title, description: String?
    var price: Int?
    var discountPercentage, rating: Double?
    var stock: Int?
    var brand, category: String?
    var thumbnail: String?
    var images: [String]?
    var quantity: Int? // Bu satırı ekleyin
}
