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
    
    private var viewModel = BasketViewModel()
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBasketInfo()
    }
    
    private func setupUI() {
        self.navigationItem.title = Constants.basketTitle
        basketTableView.delegate = self
        basketTableView.dataSource = self
        basketTableView.register(BasketTableViewCell.nib(), forCellReuseIdentifier: BasketTableViewCell.identifier)
        basketCheckOutBtn.backgroundColor = .gray
        basketCheckOutBtn.layer.cornerRadius = 10
    }
    
    private func setupBindings() {
        notificationToken = viewModel.basketProducts?.observe { [weak self] _ in
            self?.basketTableView.reloadData()
            self?.updateBasketInfo()
        }
    }
    
    func updateBasketInfo() {
        let basketInfo = viewModel.updateBasketInfo()
        basketPriceLabel.text = basketInfo.subtotal
        basketDiscountLabel.text = basketInfo.discount
        basketTotalLabel.text = basketInfo.total
        updateTabBarBadge()
    }
    
    private func updateTabBarBadge() {
        let totalItems = viewModel.numberOfProducts
        if totalItems > 0 {
            tabBarController?.tabBar.items?[2].badgeValue = "\(totalItems)"
        } else {
            tabBarController?.tabBar.items?[2].badgeValue = nil
        }
    }
    
    
    @IBAction func basketCheckOutBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toPaySegue", sender: nil)
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = basketTableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as! BasketTableViewCell
        if let product = viewModel.product(at: indexPath.row) {
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
            viewModel.removeProduct(at: indexPath.row)
            updateBasketInfo()
        }
    }
}
