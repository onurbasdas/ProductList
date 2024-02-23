//
//  CartManager.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import Foundation
import RealmSwift

class CartManager {
    static let shared = CartManager()
    private var realm: Realm

    init() {
        realm = try! Realm()
    }

    func addProductToCart(_ product: CartProduct) {
        try! realm.write {
            realm.add(product, update: .modified)
        }
    }

    func removeProductFromCart(_ product: CartProduct) {
        if let cartProduct = realm.object(ofType: CartProduct.self, forPrimaryKey: product.id) {
            try! realm.write {
                realm.delete(cartProduct)
            }
        }
    }

    func updateProductQuantityInCart(productId: Int, quantity: Int) {
        if let cartProduct = realm.object(ofType: CartProduct.self, forPrimaryKey: productId) {
            try! realm.write {
                cartProduct.quantity = quantity
            }
        }
    }
   
    func isProductInCart(_ product: CartProduct) -> Bool {
        return realm.object(ofType: CartProduct.self, forPrimaryKey: product.id) != nil
    }
    
    func totalProductsInCart() -> Int {
        let cartProducts = realm.objects(CartProduct.self)
        return cartProducts.reduce(0) { $0 + $1.quantity }
    }
}
