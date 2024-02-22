//
//  ProductListViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productListSearchBar: UISearchBar!
    @IBOutlet weak var productListTitleLabel: UILabel!
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var productListFilterBtn: UIButton!
    @IBOutlet weak var productListSortBtn: UIButton!
    
    let viewModel = ProductListViewModel()
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var isAscendingOrder = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        productListTableView.dataSource = self
        productListTableView.delegate = self
        productListTableView.register(ProductListTableViewCell.nib(), forCellReuseIdentifier: ProductListTableViewCell.identifier)
        productListSearchBar.delegate = self
        fetchData()
    }
    
    private func configureLabel() {
        let text = "Ürünler (Toplam \(products.count) adet)"
        let attributedString = NSMutableAttributedString(string: text)
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17),
            .foregroundColor: UIColor.black
        ]
        attributedString.addAttributes(boldAttributes, range: (text as NSString).range(of: "Ürünler"))
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.gray
        ]
        
        attributedString.addAttributes(normalAttributes, range: NSRange(location: 0, length: text.count))
        productListTitleLabel.attributedText = attributedString
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
            self.filteredProducts = products
            DispatchQueue.main.async { [weak self] in
                self?.configureLabel()
                self?.productListTableView.reloadData()
            }
        }
    }
    
    func handleFailure(error: NetworkError) {
        print("Network error: \(error)")
    }
    
    @IBAction func productListFilterBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func productListSortBtnPressed(_ sender: UIButton) {
        isAscendingOrder = !isAscendingOrder
        let sortedProducts = products.sorted { (product1, product2) -> Bool in
            if isAscendingOrder {
                return (product1.price ?? 0) < (product2.price ?? 0)
            } else {
                return (product1.price ?? 0) > (product2.price ?? 0)
            }
        }
        updateUI(with: sortedProducts)
    }
    
    func updateUI(with sortedProducts: [Product]) {
        self.filteredProducts = sortedProducts
        self.productListTableView.reloadData()
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as! ProductListTableViewCell
        cell.bind(data: filteredProducts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProductVC = storyboard?.instantiateViewController(withIdentifier: "ProductListDetailViewController") as! ProductListDetailViewController
        selectedProductVC.selectedProduct = filteredProducts[indexPath.row]
        navigationController?.pushViewController(selectedProductVC, animated: true)
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
        productListTableView.reloadData()
    }
}
