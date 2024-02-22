//
//  ProductListViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productListTitleLabel: UILabel!
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var productListFilterBtn: UIButton!
    @IBOutlet weak var productListSortBtn: UIButton!
    
    let viewModel = ProductListViewModel()
    var products: [Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        productListTableView.dataSource = self
        productListTableView.delegate = self
        productListTableView.register(ProductListTableViewCell.nib(), forCellReuseIdentifier: ProductListTableViewCell.identifier)
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
        
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as! ProductListTableViewCell
        cell.bind(data: products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProductVC = storyboard?.instantiateViewController(withIdentifier: "ProductListDetailViewController") as! ProductListDetailViewController
        selectedProductVC.selectedProduct = products[indexPath.row]
        navigationController?.pushViewController(selectedProductVC, animated: true)
    }

    
}
