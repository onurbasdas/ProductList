//
//  FavoriteViewController.swift
//  ProductList
//
//  Created by Onur on 21.02.2024.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    private var viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavoriteProducts()
        favoriteCollectionView.reloadData()
    }
    
    
    func setupUI() {
        navigationItem.title = Constants.favoriteTitle
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(FavoriteCollectionViewCell.nib(), forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfFavorites()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as! FavoriteCollectionViewCell
        if let product = viewModel.product(at: indexPath.item) {
            cell.bind(data: product)
            cell.delegate = self
        }
        return cell
    }
}

extension FavoriteViewController: FavoriteCollectionViewCellDelegate {
    func didSelectFavorite(cell: UICollectionViewCell) {
        if let indexPath = favoriteCollectionView.indexPath(for: cell),
           let product = viewModel.product(at: indexPath.row) {
            viewModel.toggleFavorite(for: product)
            favoriteCollectionView.deleteItems(at: [indexPath])
        }
    }
}
