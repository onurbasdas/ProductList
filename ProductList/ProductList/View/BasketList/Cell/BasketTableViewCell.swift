//
//  BasketTableViewCell.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import UIKit
import SDWebImage

class BasketTableViewCell: UITableViewCell {
    
    static let identifier = "BasketTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "BasketTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var basketTitleLabel: UILabel!
    @IBOutlet weak var basketDescLabel: UILabel!
    @IBOutlet weak var basketRemoveProductBtn: UIButton!
    @IBOutlet weak var basketTotalLabel: UILabel!
    @IBOutlet weak var basketAddProductBtn: UIButton!
    
    var product: Product?
    var quantity: Int = 0 {
        didSet {
            basketTotalLabel.text = "\(quantity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bind(data: Product) {
        basketImageView.sd_setImage(with: URL(string: data.thumbnail ?? ""))
        basketTitleLabel.text = data.title
        basketDescLabel.text = data.description
    }
    
    @IBAction func basketRemoveProductBtnPressed(_ sender: UIButton) {
        if quantity > 0 {
            quantity -= 1
        }
    }
    
    @IBAction func basketAddProductBtnPressed(_ sender: UIButton) {
        quantity += 1
    }
    
    @IBAction func basketDeleteProductBtnPressed(_ sender: UIButton) {
        
    }
    
}
