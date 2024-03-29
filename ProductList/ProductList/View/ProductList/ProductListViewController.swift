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
    var isAscendingOrder = true
    var selectedBrands: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        productListTableView.dataSource = self
        productListTableView.delegate = self
        productListSearchBar.delegate = self
        productListTableView.register(ProductListTableViewCell.nib(), forCellReuseIdentifier: ProductListTableViewCell.identifier)
        configureButton()
        fetchData()
    }
    
    private func configureLabel() {
        let text = "Ürünler (Toplam \(viewModel.filteredProducts.count) adet)"
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
        
        attributedString.addAttributes(normalAttributes, range: NSRange(location: "Ürünler".count, length: text.count - "Ürünler".count))
        
        productListTitleLabel.attributedText = attributedString
    }
    
    
    private func configureButton() {
        productListFilterBtn.layer.borderWidth = 1
        productListFilterBtn.layer.borderColor = UIColor.gray.cgColor
        productListFilterBtn.layer.cornerRadius = 8
        productListSortBtn.layer.borderWidth = 1
        productListSortBtn.layer.borderColor = UIColor.gray.cgColor
        productListSortBtn.layer.cornerRadius = 8
    }
    
    func fetchData() {
        viewModel.fetchProductList { [weak self] result in
            switch result {
            case .success:
                self?.handleSuccess()
            case .failure(let error):
                self?.handleFailure(error: error)
            }
        }
    }
    
    func handleSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.configureLabel()
            self?.productListTableView.reloadData()
        }
    }
    
    func handleFailure(error: NetworkError) {
        print("Network error: \(error)")
    }
    
    @IBAction func productListFilterBtnPressed(_ sender: UIButton) {
        showFilterAlert()
    }
    
    private func showFilterAlert() {
        let filterAlert = FilterAlertController(title: "Filter Brands", message: nil, preferredStyle: .alert)
        filterAlert.filterDelegate = self

        filterAlert.addRemoveAllAction()

        for brand in viewModel.brandList {
            let isSelected = selectedBrands.contains(brand)
            filterAlert.addAction(withBrand: brand, isSelected: isSelected)
        }

        present(filterAlert, animated: true, completion: nil)
    }
    
    @IBAction func productListSortBtnPressed(_ sender: UIButton) {
        viewModel.isAscendingOrder.toggle()
        viewModel.sortProducts()
        productListTableView.reloadData()
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as! ProductListTableViewCell
        cell.bind(data: viewModel.filteredProducts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProductVC = storyboard?.instantiateViewController(withIdentifier: "ProductListDetailViewController") as! ProductListDetailViewController
        selectedProductVC.selectedProduct = viewModel.filteredProducts[indexPath.row]
        navigationController?.pushViewController(selectedProductVC, animated: true)
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchProducts(searchText: searchText)
        productListTableView.reloadData()
        self.configureLabel()
    }
}

extension ProductListViewController: FilterAlertDelegate {
    func didSelectBrands(_ brands: [String]) {
        selectedBrands = brands
        viewModel.filterProductsByBrands(brands: selectedBrands)
        productListTableView.reloadData()
    }

    func removeAllBrands() {
        selectedBrands.removeAll()
        viewModel.filterProductsByBrands(brands: selectedBrands)
        productListTableView.reloadData()
    }
}
