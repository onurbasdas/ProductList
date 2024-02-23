//
//  FavoriteViewModel.swift
//  ProductList
//
//  Created by Onur on 23.02.2024.
//

import Foundation

import Foundation

class FavoriteViewModel {
    
    var favoriteProducts: [Product] = []
    
    func loadFavoriteProducts() {
        if let encodedData = UserDefaults.standard.value(forKey: "favoriteProducts") as? Data,
           let storedProducts = try? PropertyListDecoder().decode([Product].self, from: encodedData) {
            self.favoriteProducts = storedProducts
        }
    }
    
    func toggleFavorite(for product: Product) {
        if let index = favoriteProducts.firstIndex(where: { $0.id == product.id }) {
            favoriteProducts.remove(at: index)
        } else {
            favoriteProducts.append(product)
        }
        
        if let encodedData = try? PropertyListEncoder().encode(favoriteProducts) {
            UserDefaults.standard.set(encodedData, forKey: "favoriteProducts")
        }
    }
    
    func numberOfFavorites() -> Int {
        return favoriteProducts.count
    }
    
    func product(at index: Int) -> Product? {
        if index >= 0 && index < favoriteProducts.count {
            return favoriteProducts[index]
        }
        return nil
    }
}
