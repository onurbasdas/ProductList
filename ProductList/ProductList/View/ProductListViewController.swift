//
//  ProductListViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productListTableView: UITableView!
    
    let viewModel = ProductListViewModel()
    var products: [Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        productListTableView.dataSource = self
        productListTableView.delegate = self
        fetchData()
    }
    
    func fetchData() {
        viewModel.fetchProductList { [weak self] result in
            switch result {
            case .success(let productList):
                self?.handleSuccess(productList: productList)
            case .failure(let error):
                self?.handleFailure(error: error)
            }
        }
    }
    
    func handleSuccess(productList: ProductListModel) {
        if let products = productList.products {
            self.products = products
            DispatchQueue.main.async { [weak self] in
                self?.productListTableView.reloadData()
            }
        }
    }
    
    func handleFailure(error: NetworkError) {
        print("Network error: \(error)")
    }
    
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = products[indexPath.row].title
        return cell
    }
}
