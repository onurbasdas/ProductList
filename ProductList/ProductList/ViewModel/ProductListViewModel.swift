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
    var brandList: [String] = []
    
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
    
    
    func filterProductsByBrands(brands: [String]) {
        if brands.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                return brands.contains(product.brand ?? "")
            }
        }
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
    
    func fetchProductList(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let urlString = Constants.apiURL
        NetworkManager.shared.fetchData(from: urlString, method: .get) { [weak self] (result: Result<ProductListModel, NetworkError>) in
            switch result {
            case .success(let productList):
                if let products = productList.products {
                    self?.products = products
                    self?.filteredProducts = products
                    self?.brandList = Set(products.compactMap { $0.brand }).sorted()
                    completion(.success(()))
                } else {
                    completion(.failure(.invalidURL))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
