//
//  FavoriteCollectionViewCell.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import UIKit

protocol FavoriteCollectionViewCellDelegate: AnyObject {
    func didSelectFavorite(cell: UICollectionViewCell)
}

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoriteCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
    }

    @IBOutlet weak var favoriteBgView: UIView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteTitleLabel: UILabel!
    @IBOutlet weak var favoriteDescLabel: UILabel!
    @IBOutlet weak var favoritePriceLabel: UILabel!
    @IBOutlet weak var favoriteCellBtn: UIButton!
    @IBOutlet weak var favoriteAddCartBtn: UIButton!
    
    weak var delegate: FavoriteCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteBgView.layer.cornerRadius = 10
        favoriteImageView.layer.cornerRadius = 10
        favoriteCellBtn.layer.cornerRadius = 10
        favoriteAddCartBtn.layer.cornerRadius = 15
    }

    func bind(data: Product) {
        favoriteImageView.sd_setImage(with: URL(string: data.thumbnail ?? ""))
        favoriteTitleLabel.text = data.title
        favoriteDescLabel.text = data.description
        favoritePriceLabel.text = "\(data.price ?? 0) TL"
    }
    
    @IBAction func favoriteCellBtnPressed(_ sender: UIButton) {
        self.delegate?.didSelectFavorite(cell: self)
    }
    
    @IBAction func favoriteAddCartBtnPressed(_ sender: UIButton) {
        
    }
    
    
}
