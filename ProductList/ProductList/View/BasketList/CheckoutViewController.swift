//
//  CheckoutViewController.swift
//  ProductList
//
//  Created by Onur Başdaş on 22.02.2024.
//

import UIKit

class CheckoutViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var checkoutNameTf: UITextField!
    @IBOutlet weak var checkoutEmailTf: UITextField!
    @IBOutlet weak var checkoutPhoneTf: UITextField!
    @IBOutlet weak var checkoutPayBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let textFields = [checkoutNameTf, checkoutEmailTf, checkoutPhoneTf]
        textFields.forEach { textField in
            textField?.delegate = self
            textField?.layer.cornerRadius = 10
            textField?.layer.borderWidth = 1
            textField?.layer.borderColor = UIColor.black.cgColor
        }
        checkoutPayBtn.backgroundColor = .gray
        checkoutPayBtn.layer.cornerRadius = 10
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
    }
    
    @IBAction func checkoutPayBtnPressed(_ sender: UIButton) {
        if checkoutNameTf.text == "" || checkoutEmailTf.text == "" || checkoutPhoneTf.text == "" {
            validateTextField(checkoutNameTf)
            validateTextField(checkoutEmailTf)
            validateTextField(checkoutPhoneTf)
        } else {
            let alert = UIAlertController(title: "Purchase", message: "Would you like to proceed with the purchase?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                print("Purchasing...")
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    private func validateTextField(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1
        } else {
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 0
        }
    }
}
