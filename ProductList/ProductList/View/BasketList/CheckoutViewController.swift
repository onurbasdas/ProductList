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
        checkoutNameTf.delegate = self
        checkoutEmailTf.delegate = self
        checkoutPhoneTf.delegate = self
        
        // Diğer gerekli işlemleri de ekleyebilirsiniz
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = "Enter \(textField.placeholder ?? "")"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.placeholder = "Field is required"
        } else {
            textField.layer.borderColor = UIColor.black.cgColor
            textField.placeholder = "Enter \(textField.placeholder ?? "")"
        }
    }
    
    
    
    @IBAction func checkoutPayBtnPressed(_ sender: UIButton) {
        
    }
}
