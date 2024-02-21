//
//  ProductListViewModel.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import Foundation

class ProductListViewModel {
    
    func fetchProductList(completion: @escaping (Result<ProductListModel, NetworkError>) -> Void) {
        let urlString = "https://dummyjson.com/products"
        NetworkManager.shared.fetchData(from: urlString, method: .get) { (result: Result<ProductListModel, NetworkError>) in
            completion(result)
        }
    }
    
}
