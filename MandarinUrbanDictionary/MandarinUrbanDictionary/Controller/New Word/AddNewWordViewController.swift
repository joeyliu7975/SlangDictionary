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
    
    var buttonIsValid: Bool = false {
        
        didSet {
            
            switch buttonIsValid {
            
            case true:
                
                sendButton.backgroundColor = .white
                
            case false:
                
                sendButton.backgroundColor = .lightGray
                
            }

            sendButton.isEnabled = buttonIsValid
        }
    }
    
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
        guard
            let word = newWordTF.text,
            let definition = definitionTextView.text,
            let category = categoryTF.text
        else {
            return
        }
        
        let newWord = Word(
            name: word,
            definition: [definition],
            category: category,
            view: 0,
            id: "1234567890",
            time: Date(timeIntervalSince1970: 12469403928984)
        )
        
        // Call Firebase then after firebase receive result dismiss this Page
        
        self.dismiss(animated: true)
    }
}

extension AddNewWordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkFormValidation()
        
    }
}

extension AddNewWordViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        checkFormValidation()
        
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
        
        let icon = categoryList[row].makeIcon()
        
        return categoryTF.text = icon.name
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let icon = categoryList[row].makeIcon()
        
        return icon.name
    }
}

private extension AddNewWordViewController {
    func setup() {
        
        newWordTF.delegate = self
        
        categoryTF.delegate = self
        
        definitionTextView.delegate = self
        
        checkFormValidation()
        
        definitionTextView.setCorner(radius: 15)
        
        sendButton.setCorner(radius: 10)
        
        navigationItem.setBarAppearance(with: .separatorlineBlue)
        
        view.backgroundColor = .separatorlineBlue
        
        containerView.backgroundColor = .separatorlineBlue
        
        pickerView = UIPickerView()
    }
    
    func checkFormValidation() {
        
        guard
            let word = newWordTF.text,
            let definition = definitionTextView.text,
            let category = categoryTF.text,
            !word.isEmpty,
            !definition.isEmpty,
            !category.isEmpty
        else {

            buttonIsValid = false
            
            return
        }
        
        buttonIsValid = true
        
    }
}
