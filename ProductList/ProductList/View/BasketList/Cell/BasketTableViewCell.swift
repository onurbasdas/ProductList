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
    
    var product: CartProduct?
    var quantity: Int = 1 {
        didSet {
            basketTotalLabel.text = "\(quantity)"
        }
    }
    weak var delegate: BasketTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        basketBgView.layer.cornerRadius = 10
        if quantity == 1 {
            basketRemoveProductBtn.tintColor = .gray
        } else {
            basketRemoveProductBtn.tintColor = UIColor(named: "color3")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bind(data: CartProduct) {
        self.product = data
        basketImageView.sd_setImage(with: URL(string: data.thumbnail ))
        basketTitleLabel.text = data.title
        basketTotalLabel.text = "\(data.quantity)"
        quantity = data.quantity
        
        let price = Double(data.price)
        let discountPercentage = data.discountPercentage
        let discountedPrice = price * (1 - (discountPercentage / 100))
        
        let priceString = String(format: "%.2f", price)
        let attributedString = NSMutableAttributedString(string: "\(priceString) TL")
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        basketPriceLabel.attributedText = attributedString
        
        let discountedPriceString = String(format: "%.2f", discountedPrice)
        basketDiscountPriceLabel.text = "\(discountedPriceString) TL"
    }
    
    @IBAction func basketRemoveProductBtnPressed(_ sender: UIButton) {
        if quantity > 1 {
            quantity -= 1
            updateCartQuantity()
        } else {
            basketRemoveProductBtn.tintColor = .gray
        }
    }
    
    @IBAction func basketAddProductBtnPressed(_ sender: UIButton) {
        quantity += 1
        updateCartQuantity()
    }
    
    @IBAction func basketDeleteProductBtnPressed(_ sender: UIButton) {
        self.delegate?.didRemoveBasket(cell: self)
    }
    
    private func updateCartQuantity() {
        guard let product = product else { return }
        let realm = try! Realm()
        try! realm.write {
            product.quantity = quantity
            realm.add(product, update: .modified)
            delegate?.didUpdateQuantity()
        }
    }
}
