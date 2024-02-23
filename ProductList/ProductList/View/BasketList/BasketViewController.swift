//
//  BasketViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit
import RealmSwift

class BasketViewController: UIViewController {
    
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var basketPriceLabel: UILabel!
    @IBOutlet weak var basketDiscountLabel: UILabel!
    @IBOutlet weak var basketTotalLabel: UILabel!
    @IBOutlet weak var basketCheckOutBtn: UIButton!
    
    var basketProducts: Results<CartProduct>?
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBasketInfo()
    }
    
    func setupUI() {
        self.navigationItem.title = Constants.basketTitle
        basketTableView.delegate = self
        basketTableView.dataSource = self
        basketTableView.register(BasketTableViewCell.nib(), forCellReuseIdentifier: BasketTableViewCell.identifier)
        basketCheckOutBtn.backgroundColor = .gray
        basketCheckOutBtn.layer.cornerRadius = 10
    }
    
    func setupRealm() {
        let realm = try! Realm()
        basketProducts = realm.objects(CartProduct.self)
        notificationToken = basketProducts?.observe { [weak self] _ in
            self?.basketTableView.reloadData()
            self?.updateBasketInfo()
        }
    }
    
    func updateBasketInfo() {
        guard let basketProducts = basketProducts else { return }
        
        var subtotal = 0
        var totalDiscount = 0.0
        for product in basketProducts {
            let productTotal = product.price * product.quantity
            let productDiscount = Double(productTotal) * product.discountPercentage / 100
            subtotal += productTotal
            totalDiscount += productDiscount
        }
        
        let totalPrice = Double(subtotal) - totalDiscount
        basketPriceLabel.text = "\(subtotal) TL"
        basketDiscountLabel.text = "\(Int(totalDiscount)) TL"
        basketTotalLabel.text = "\(Int(totalPrice)) TL"
    }

    @IBAction func basketCheckOutBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toPaySegue", sender: nil)
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = basketTableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as! BasketTableViewCell
        if let product = basketProducts?[indexPath.row] {
            cell.bind(data: product)
            cell.delegate = self
        }
        return cell
    }
}

extension BasketViewController: BasketTableViewCellDelegate {
    func didUpdateQuantity() {
        updateBasketInfo()
    }
    
    func didRemoveBasket(cell: UITableViewCell) {
        if let indexPath = basketTableView.indexPath(for: cell) {
            if let removedProduct = basketProducts?[indexPath.row] {
                CartManager.shared.removeProductFromCart(removedProduct)
            }
        }
    }
}
