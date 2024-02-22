//
//  ProductDetailSliderCollectionViewCell.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import UIKit

class ProductDetailSliderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductDetailSliderCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ProductDetailSliderCollectionViewCell", bundle: nil)
    }

    @IBOutlet weak var productDetailSliderImageView: UIImageView!
    @IBOutlet weak var productDetailSliderPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productDetailSliderPriceLabel.layer.cornerRadius = 20
        productDetailSliderPriceLabel.clipsToBounds = true
    }
}
