//
//  ProductListTableViewCell.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit
import SDWebImage

class ProductListTableViewCell: UITableViewCell {
    
    static let identifier = "ProductListTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ProductListTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var productBgView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescLabel: UILabel!
    @IBOutlet weak var productDiscountPriceLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        productBgView.layer.cornerRadius = 10
    }
    
    func bind(data: Product) {
        productImageView.sd_setImage(with: URL(string: data.thumbnail ?? ""))
        productTitleLabel.text = data.title
        productDescLabel.text = data.description
        
        let price = Double(data.price ?? 0)
        let discountPercentage = data.discountPercentage ?? 0
        let discountedPrice = price * (1 - (discountPercentage / 100))
        
        let priceString = String(format: "%.2f", price)
        let attributedString = NSMutableAttributedString(string: "\(priceString) TL")
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        productPriceLabel.attributedText = attributedString
        
        let discountedPriceString = String(format: "%.2f", discountedPrice)
        productDiscountPriceLabel.text = "\(discountedPriceString) TL"
    }

    
}
