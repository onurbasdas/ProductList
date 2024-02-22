//
//  BasketViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit

class BasketViewController: UIViewController {
    
    @IBOutlet weak var basketTableView: UITableView!
    
    var basketProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCartProducts()
    }
    
    func setupUI() {
        self.navigationItem.title = "BASKET"
        basketTableView.delegate = self
        basketTableView.dataSource = self
        basketTableView.register(BasketTableViewCell.nib(), forCellReuseIdentifier: BasketTableViewCell.identifier)
    }
    
    func loadCartProducts() {
        if let encodedData = UserDefaults.standard.value(forKey: "cartProducts") as? Data,
           let storedProducts = try? PropertyListDecoder().decode([Product].self, from: encodedData) {
            basketProducts = storedProducts
        }
        basketTableView.reloadData()
    }
    
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = basketTableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as! BasketTableViewCell
        cell.bind(data: basketProducts[indexPath.row])
        return cell
    }
    
    
}
