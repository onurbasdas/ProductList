//
//  BasketViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit

class BasketViewController: UIViewController {
    
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var basketPriceLabel: UILabel!
    @IBOutlet weak var basketDiscountLabel: UILabel!
    @IBOutlet weak var basketTotalLabel: UILabel!
    @IBOutlet weak var basketCheckOutBtn: UIButton!
    
    var basketProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCartProducts()
        updateBasketInfo()
    }
    
    func setupUI() {
        self.navigationItem.title = Constants.basketTitle
        basketTableView.delegate = self
        basketTableView.dataSource = self
        basketTableView.register(BasketTableViewCell.nib(), forCellReuseIdentifier: BasketTableViewCell.identifier)
        basketCheckOutBtn.layer.cornerRadius = 10
    }
    
    func loadCartProducts() {
        if let encodedData = UserDefaults.standard.value(forKey: "cartProducts") as? Data,
           let storedProducts = try? PropertyListDecoder().decode([Product].self, from: encodedData) {
            basketProducts = storedProducts
        }
        basketTableView.reloadData()
    }
    
    func updateBasketInfo() {
        // Sepetteki ürünlerin toplam fiyatını, indirimli toplam fiyatını ve indirimi hesapla
        let totalPrice = basketProducts.reduce(0) { $0 + ($1.price ?? 0) }
        let totalDiscountedPrice = basketProducts.reduce(0) { $0 + Int(($1.discountPercentage ?? 0)) * ($1.quantity ?? 1) }
        let totalDiscount = totalPrice - totalDiscountedPrice
        
        // Fiyat etiketlerini güncelle
        basketPriceLabel.text = "\(totalPrice) TL"
        basketDiscountLabel.text = "-\(totalDiscountedPrice) TL"
        basketTotalLabel.text = "\(totalDiscount) TL"
    }
    
    
    @IBAction func basketCheckOutBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toPaySegue", sender: nil)
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
