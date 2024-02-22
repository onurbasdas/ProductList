//
//  FavoriteCollectionViewCell.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoriteCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
