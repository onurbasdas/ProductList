//
//  ProductListDetailViewController.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import UIKit

class ProductListDetailViewController: UIViewController {
    
    @IBOutlet weak var productListDetailPageControl: UIPageControl!
    @IBOutlet weak var productListDetailImageView: UIImageView!
    @IBOutlet weak var productListDetailTitleLabel: UILabel!
    @IBOutlet weak var productListDetailDescLabel: UILabel!
    @IBOutlet weak var productListDetailPriceLabel: UILabel!
    @IBOutlet weak var productListDetailDiscountPriceLabel: UILabel!
    @IBOutlet weak var productListDetailAddCartBtn: UIButton!
    
    var selectedProduct: Product?
    var images: [UIImage] = []
    var pageViewController: UIPageViewController!
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        
        productListDetailAddCartBtn.backgroundColor = .gray
        productListDetailAddCartBtn.layer.cornerRadius = 10
        productListDetailTitleLabel.text = selectedProduct?.title
        productListDetailDescLabel.text = selectedProduct?.description
        let price = Double(selectedProduct?.price ?? 0)
        let discountPercentage = selectedProduct?.discountPercentage ?? 0
        let discountedPrice = price * (1 - (discountPercentage / 100))
        
        let priceString = String(format: "%.2f", price)
        let attributedString = NSMutableAttributedString(string: "\(priceString) TL")
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        productListDetailPriceLabel.attributedText = attributedString
        
        let discountedPriceString = String(format: "%.2f", discountedPrice)
        productListDetailDiscountPriceLabel.text = "\(discountedPriceString) TL"
        navigationItem.title = selectedProduct?.title
    }
    
    @IBAction func productListDetailAddCartBtnPressed(_ sender: UIButton) {
        
    }
    
    
}
