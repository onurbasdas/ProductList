//
//  FavoriteManager.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    
    private init() {}
    
    private var favoriteProducts: [Product] {
        get {
            if let data = UserDefaults.standard.value(forKey: "favoriteProducts") as? Data,
               let products = try? PropertyListDecoder().decode([Product].self, from: data) {
                return products
            }
            return []
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "favoriteProducts")
            }
        }
    }
    
    func isProductFavorite(_ product: Product) -> Bool {
        return favoriteProducts.contains(where: { $0.id == product.id })
    }
    
    func toggleFavorite(_ product: Product) {
        if isProductFavorite(product) {
            favoriteProducts.removeAll { $0.id == product.id }
        } else {
            favoriteProducts.append(product)
        }
        saveFavorites()
    }
    
    func getFavoriteProducts() -> [Product] {
        return favoriteProducts
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteProducts), forKey: "favoriteProducts")
    }
}
