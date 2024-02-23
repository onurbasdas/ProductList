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
    
    @IBOutlet weak var productListDetailFavoriteBtn: UIBarButtonItem!
    var selectedProduct: Product?
    var images: [UIImage] = []
    var isFavoriteToCart: Bool = false
    var isAddedToCart: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedProduct = selectedProduct {
            let cartProduct = convertToCartProduct(product: selectedProduct)
            
            if CartManager.shared.isProductInCart(cartProduct) {
                isAddedToCart = true
                let buttonText = "REMOVE FROM CART"
                productListDetailAddCartBtn.setTitle(buttonText, for: .normal)
            }
        }
        
        if let data = UserDefaults.standard.value(forKey: "favoriteProducts") as? Data,
           let previousFavoriteProducts = try? PropertyListDecoder().decode([Product].self, from: data),
           let selectedProduct = selectedProduct,
           previousFavoriteProducts.contains(where: { $0.id == selectedProduct.id }) {
            isFavoriteToCart = true
            productListDetailFavoriteBtn.tintColor = .red
        }
    }
    
    private func setupUI() {
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        productListCollectionView.register(ProductDetailSliderCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductDetailSliderCollectionViewCell.identifier)
        productListDetailAddCartBtn.backgroundColor = .gray
        productListDetailAddCartBtn.layer.cornerRadius = 10
        productListDetailTitleLabel.text = selectedProduct?.title
        productListDetailDescLabel.text = selectedProduct?.description
        
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
    
    func convertToCartProduct(product: Product) -> CartProduct {
        let cartProduct = CartProduct()
        cartProduct.id = product.id ?? 0
        cartProduct.title = product.title ?? ""
        cartProduct.desc = product.description
        cartProduct.price = product.price ?? 0
        cartProduct.thumbnail = product.thumbnail ?? ""
        cartProduct.quantity = 1
        cartProduct.discountPercentage = product.discountPercentage ?? 0.0
        return cartProduct
    }
    
    @IBAction func productListDetailAddCartBtnPressed(_ sender: UIButton) {
        isAddedToCart.toggle()
        let buttonText = isAddedToCart ? "REMOVE FROM CART" : "ADD TO CART"
        productListDetailAddCartBtn.setTitle(buttonText, for: .normal)
        
        if let selectedProduct = selectedProduct {
            let cartProduct = convertToCartProduct(product: selectedProduct)
            
            if isAddedToCart {
                CartManager.shared.addProductToCart(cartProduct)
            } else {
                CartManager.shared.removeProductFromCart(cartProduct)
            }
        }
    }
    
    @IBAction func productListFavoriteBtnPressed(_ sender: UIBarButtonItem) {
        isFavoriteToCart.toggle()
        let buttonColor = isFavoriteToCart ? UIColor.red : UIColor.black
        sender.tintColor = buttonColor
        if let selectedProduct = selectedProduct {
            FavoriteManager.shared.toggleFavorite(selectedProduct)
        }
    }
}


extension ProductListDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productListCollectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailSliderCollectionViewCell.identifier, for: indexPath) as! ProductDetailSliderCollectionViewCell
        cell.productDetailSliderImageView.image = images[indexPath.item]
        let discountPercentage = selectedProduct?.discountPercentage ?? 0.0
        let formattedDiscount = String(format: "%.0f", discountPercentage)
        cell.productDetailSliderPriceLabel.text = "%\(formattedDiscount)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productListCollectionView.frame.width, height: productListCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
