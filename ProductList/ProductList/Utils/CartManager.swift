//
//  CartManager.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    private init() {}

    private var cartProducts: [Product] {
        get {
            if let data = UserDefaults.standard.value(forKey: "cartProducts") as? Data,
               let products = try? PropertyListDecoder().decode([Product].self, from: data) {
                return products
            }
            return []
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "cartProducts")
            }
        }
    }

    func addProductToCart(_ product: Product) {
        cartProducts.append(product)
        updateCartInUserDefaults()
    }

    func removeProductFromCart(_ product: Product) {
        cartProducts.removeAll { $0.id == product.id }
        updateCartInUserDefaults()
    }

    func updateCartProducts(_ products: [Product]) {
        cartProducts = products
        updateCartInUserDefaults()
    }

    func getCartProducts() -> [Product] {
        return cartProducts
    }

    private func updateCartInUserDefaults() {
        do {
            let encodedData = try PropertyListEncoder().encode(cartProducts)
            UserDefaults.standard.set(encodedData, forKey: "cartProducts")
        } catch {
            print("Error encoding cart products: \(error.localizedDescription)")
        }
    }
}
