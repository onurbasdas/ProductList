//
//  FilterAlertViewController.swift
//  ProductList
//
//  Created by Onur Başdaş on 23.02.2024.
//

import UIKit

protocol FilterAlertDelegate: AnyObject {
    func didSelectBrands(_ brands: [String])
    func removeAllBrands()
}

class FilterAlertController: UIAlertController {
    weak var filterDelegate: FilterAlertDelegate?

    func addAction(withBrand brand: String, isSelected: Bool) {
        let action = UIAlertAction(title: brand, style: .default) { [weak self] _ in
            self?.toggleBrandSelection(brand)
        }
        action.setValue(isSelected, forKey: "checked")
        addAction(action)
    }

    private func toggleBrandSelection(_ brand: String) {
        filterDelegate?.didSelectBrands([brand])
    }

    func addRemoveAllAction() {
        let action = UIAlertAction(title: "Remove All", style: .destructive) { [weak self] _ in
            self?.filterDelegate?.removeAllBrands()
        }
        addAction(action)
    }
}
