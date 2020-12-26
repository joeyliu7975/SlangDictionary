//
//  AddNewWordView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/18/20.
//

import UIKit

protocol AddNewWordViewDelegate: class, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate {
    func clickCancel()
    func clickSend(_ view: UIView, newWord: String?, definition: String?, category: String?)
    func clikckDone(categoryTextField: UITextField)
}

class AddNewWordView: UIView {
    
    weak var delegate: AddNewWordViewDelegate? {
        didSet {
            guard let delegate = self.delegate else { return }
            newWordTF.delegate = delegate
            categoryTF.delegate = delegate
            definitionTextView.delegate = delegate
            pickerView?.delegate = delegate
        }
    }
        
    @IBOutlet weak var newWordTF: UITextField!
    
    @IBOutlet weak var definitionTextView: UITextView! {
        didSet {
            definitionTextView.setCorner(radius: 10)
            
            definitionTextView.textingStatus(with: .placeHolder)
            
            definitionTextView.text = "請在此新增字詞解釋..."
        }
    }
    
    @IBOutlet weak var categoryTF: UITextField! {
        didSet {
            let toolBar = UIToolbar()
            
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.homepageDarkBlue
            toolBar.sizeToFit()
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
            
            toolBar.setItems([spacer, spacer, doneButton], animated: false)
            
            toolBar.isUserInteractionEnabled = true
            
            categoryTF.inputAccessoryView = toolBar
        }
    }
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.setCorner(radius: 10)
        }
    }
    
    @IBOutlet weak var limitOfWord: UILabel!

    var pickerView: UIPickerView? {
        didSet {
            
            guard let picker = pickerView else { return }
            
            categoryTF.inputView = picker
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))

            self.addGestureRecognizer(tap)
        }
    }

    @objc func closeKeyboard() {
        self.endEditing(true)
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        
        delegate?.clickCancel()
        
    }
    
    @IBAction func clickSend(_ sender: UIButton) {

        delegate?.clickSend(self, newWord: newWordTF.text, definition: definitionTextView.text, category: categoryTF.text)
        
    }
    
    @objc func donePicker() {
        
        delegate?.clikckDone(categoryTextField: categoryTF)
        
    }
    
}

extension AddNewWordView {
    func updateText<T: UITextInput>(target: T?, with text: String) {
        if let textField = target as? UITextField {
            textField.text = text
        } else if let textView = target as? UITextView {
            textView.text = text
        }
    }
    
    func updateLimitOfWord(number: Int) {
        limitOfWord.text = "可用字數: \(number)"
    }
    
    func sendButtonValidation(_ isValid: Bool) {
        sendButton.backgroundColor = isValid ? .white : .lightGray
        
        sendButton.isEnabled = isValid
    }
}
