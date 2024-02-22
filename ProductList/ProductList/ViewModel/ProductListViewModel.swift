//
//  ProductListViewModel.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import Foundation

class ProductListViewModel {
    
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var isAscendingOrder = true
    
    func sortProducts() {
         let sortedProducts = products.sorted { (product1, product2) -> Bool in
             if isAscendingOrder {
                 return (product1.price ?? 0) < (product2.price ?? 0)
             } else {
                 return (product1.price ?? 0) > (product2.price ?? 0)
             }
         }
         filteredProducts = sortedProducts
     }
    
    func searchProducts(searchText: String) {
           if searchText.isEmpty {
               filteredProducts = products
           } else {
               filteredProducts = products.filter {
                   if let name = $0.title {
                       return name.lowercased().contains(searchText.lowercased())
                   }
                   return false
               }
           }
       }
    
    func fetchProductList(completion: @escaping (Result<ProductListModel, NetworkError>) -> Void) {
        let urlString = Constants.apiURL
        NetworkManager.shared.fetchData(from: urlString, method: .get) { (result: Result<ProductListModel, NetworkError>) in
            completion(result)
        }
    }
    
}
