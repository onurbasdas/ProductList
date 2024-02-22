//
//  FavoriteViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI() {
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(FavoriteCollectionViewCell.nib(), forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
    }

}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}
