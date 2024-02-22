//
//  FavoriteViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    var favoriteProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteProducts()
    }
    
    
    func setupUI() {
        navigationItem.title = "FAVORITE"
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(FavoriteCollectionViewCell.nib(), forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
    }
    
    func loadFavoriteProducts() {
          if let encodedData = UserDefaults.standard.value(forKey: "favoriteProducts") as? Data,
             let storedProducts = try? PropertyListDecoder().decode([Product].self, from: encodedData) {
              favoriteProducts = storedProducts
          }
          favoriteCollectionView.reloadData()
      }

}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as! FavoriteCollectionViewCell
        cell.bind(data: favoriteProducts[indexPath.item])
        return cell
    }
    
}
