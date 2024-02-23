//
//  CartProduct.swift
//  ProductList
//
//  Created by Onur Başdaş on 23.02.2024.
//

import Foundation
import RealmSwift

class CartProduct: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var thumbnail: String = ""
    @objc dynamic var desc: String? // Eğer açıklama zorunlu değilse optional olabilir
    @objc dynamic var price: Int = 0
    @objc dynamic var quantity: Int = 1 // Sepete eklenen ürün miktarı

    override static func primaryKey() -> String? {
        return "id"
    }
}
