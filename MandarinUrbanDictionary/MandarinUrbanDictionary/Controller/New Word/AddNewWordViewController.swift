//
//  AddNewWordViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class AddNewWordViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newWordTF: UITextField!
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let categoryList = Category.allCases
    
    private var pickerView: UIPickerView? {
        didSet {
            guard let picker = pickerView else { return }
            
            picker.delegate = self
            picker.dataSource = self
            
            categoryTF.inputView = picker
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
            
            view.addGestureRecognizer(tap)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func clickSend(_ sender: UIButton) {
        
    }
}

extension AddNewWordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return categoryTF.text = categoryList[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].title
    }
}

private extension AddNewWordViewController {
    func setup() {
        definitionTextView.setCorner(radius: 15)
        sendButton.setCorner(radius: 10)
        
        view.backgroundColor = .separatorlineBlue
        containerView.backgroundColor = .separatorlineBlue
        
        pickerView = UIPickerView()
    }
}
