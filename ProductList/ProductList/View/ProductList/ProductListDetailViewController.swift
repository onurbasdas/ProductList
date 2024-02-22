//
//  ProductListDetailViewController.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import UIKit
import SDWebImage

class ProductListDetailViewController: UIViewController {
    
    @IBOutlet weak var productListCollectionView: UICollectionView!
    @IBOutlet weak var productListDetailTitleLabel: UILabel!
    @IBOutlet weak var productListDetailDescLabel: UILabel!
    @IBOutlet weak var productListDetailPriceLabel: UILabel!
    @IBOutlet weak var productListDetailDiscountPriceLabel: UILabel!
    @IBOutlet weak var productListDetailAddCartBtn: UIButton!
    
    var selectedProduct: Product?
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        productListDetailAddCartBtn.backgroundColor = .gray
        productListDetailAddCartBtn.layer.cornerRadius = 10
        productListDetailTitleLabel.text = selectedProduct?.title
        productListDetailDescLabel.text = selectedProduct?.description
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        setupPrice()
        loadImages()
    }
    
    
    private func setupPrice() {
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
    
    private func loadImages() {
           guard let imageStrings = selectedProduct?.images else { return }
           for imageString in imageStrings {
               if let imageUrl = URL(string: imageString) {
                   SDWebImageManager.shared.loadImage(with: imageUrl, options: .retryFailed, progress: nil) { [weak self] (image, _, _, _, _, _) in
                       if let image = image {
                           self?.images.append(image)
                           self?.productListCollectionView.reloadData()
                       }
                   }
               }
           }
       }
    
    @IBAction func productListDetailAddCartBtnPressed(_ sender: UIButton) {
        
    }
}


extension ProductListDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productListCollectionView.dequeueReusableCell(withReuseIdentifier: "productListCollectionView", for: indexPath) as! ProductDetailCollectionViewCell
        cell.productDetailImageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productListCollectionView.frame.width, height: productListCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
