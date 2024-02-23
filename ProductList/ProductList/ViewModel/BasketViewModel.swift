//
//  BasketViewModel.swift
//  ProductList
//
//  Created by Onur on 23.02.2024.
//

import Foundation
import RealmSwift

class BasketViewModel {
    var basketProducts: Results<CartProduct>?
    
    private var realm: Realm
    
    init() {
        realm = try! Realm()
        basketProducts = realm.objects(CartProduct.self)
    }
    
    var numberOfProducts: Int {
        return basketProducts?.count ?? 0
    }
    
    func product(at index: Int) -> CartProduct? {
        return basketProducts?[index]
    }
    
    func updateBasketInfo() -> (subtotal: String, discount: String, total: String) {
        guard let products = basketProducts else { return ("0 TL", "0 TL", "0 TL") }
        
        var subtotal = 0
        var totalDiscount = 0.0
        for product in products {
            let productTotal = product.price * product.quantity
            let productDiscount = Double(productTotal) * product.discountPercentage / 100
            subtotal += productTotal
            totalDiscount += productDiscount
        }
        
        let totalPrice = Double(subtotal) - totalDiscount
        return ("\(subtotal) TL", "\(Int(totalDiscount)) TL", "\(Int(totalPrice)) TL")
    }
    
    func removeProduct(at index: Int) {
        guard let product = basketProducts?[index] else { return }
        try! realm.write {
            realm.delete(product)
        }
    }
    
    func updateProductQuantity(id: Int, quantity: Int) {
        guard let product = realm.object(ofType: CartProduct.self, forPrimaryKey: id) else { return }
        try! realm.write {
            product.quantity = quantity
        }
    }
}
