//
//  BasketTableViewCell.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import UIKit
import SDWebImage
import RealmSwift

protocol BasketTableViewCellDelegate: AnyObject {
    func didRemoveBasket(cell: UITableViewCell)
    func didUpdateQuantity()
}

class BasketTableViewCell: UITableViewCell {
    
    static let identifier = "BasketTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "BasketTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var basketBgView: UIView!
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var basketTitleLabel: UILabel!
    @IBOutlet weak var basketDiscountPriceLabel: UILabel!
    @IBOutlet weak var basketPriceLabel: UILabel!
    @IBOutlet weak var basketRemoveProductBtn: UIButton!
    @IBOutlet weak var basketTotalLabel: UILabel!
    @IBOutlet weak var basketAddProductBtn: UIButton!
    
    // MARK: - Properties
    
    private var product: CartProduct?
    
    var quantity: Int = 1 {
        didSet {
            basketTotalLabel.text = "\(quantity)"
            basketRemoveProductBtn.tintColor = (quantity == 1) ? .gray : UIColor(named: "color3")
        }
    }
    
    weak var delegate: BasketTableViewCellDelegate?
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        updateRemoveButtonState()
    }
    
    // MARK: - Public Methods
    
    func bind(data: CartProduct) {
        self.product = data
        setupImageView(with: data.thumbnail)
        setupLabels(with: data)
        quantity = data.quantity
        updateRemoveButtonState()
    }
    
    // MARK: - Actions
    
    @IBAction private func basketRemoveProductBtnPressed(_ sender: UIButton) {
        if quantity > 1 {
            quantity -= 1
            updateCartQuantity()
        }
    }
    
    @IBAction private func basketAddProductBtnPressed(_ sender: UIButton) {
        quantity += 1
        updateCartQuantity()
    }
    
    @IBAction private func basketDeleteProductBtnPressed(_ sender: UIButton) {
        self.delegate?.didRemoveBasket(cell: self)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        basketBgView.layer.cornerRadius = 10
    }
    
    private func setupImageView(with imageURL: String?) {
        basketImageView.sd_setImage(with: URL(string: imageURL ?? ""))
    }
    
    private func setupLabels(with data: CartProduct) {
        basketTitleLabel.text = data.title
        basketTotalLabel.text = "\(data.quantity)"
        quantity = data.quantity
        
        let price = Double(data.price)
        let discountPercentage = data.discountPercentage
        let discountedPrice = price * (1 - (discountPercentage / 100))
        
        setupPriceLabel(with: price, discountPercentage: discountPercentage)
        setupDiscountPriceLabel(with: discountedPrice)
    }
    
    private func setupPriceLabel(with price: Double, discountPercentage: Double) {
        let priceString = String(format: "%.2f TL", price)
        let attributedString = NSMutableAttributedString(string: priceString)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        basketPriceLabel.attributedText = attributedString
    }
    
    private func setupDiscountPriceLabel(with discountedPrice: Double) {
        let discountedPriceString = String(format: "%.2f TL", discountedPrice)
        basketDiscountPriceLabel.text = discountedPriceString
    }
    
    private func updateRemoveButtonState() {
        basketRemoveProductBtn.isEnabled = (quantity > 1)
        basketRemoveProductBtn.tintColor = basketRemoveProductBtn.isEnabled ? UIColor(named: "color3") : .gray
    }
    
    private func updateCartQuantity() {
        guard let product = product else { return }
        let realm = try! Realm()
        try! realm.write {
            product.quantity = quantity
            realm.add(product, update: .modified)
        }
        delegate?.didUpdateQuantity()
        updateRemoveButtonState()
    }
}
