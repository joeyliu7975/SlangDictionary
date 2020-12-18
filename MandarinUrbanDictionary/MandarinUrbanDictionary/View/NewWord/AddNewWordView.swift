//
//  AddNewWordView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/18/20.
//

import UIKit

protocol AddNewWordViewDelegate: class {
    func clickCancel(_ view: UIView)
    func clickSend(_ view: UIView, newWord: String?, definition: String?, category: String?)
    func clikckDone(categoryTextField: UITextField)
}

class AddNewWordView: UIView {
    
    weak var delegate: AddNewWordViewDelegate?
        
    @IBOutlet weak var newWordTF: UITextField!
    
    @IBOutlet weak var definitionTextView: UITextView! {
        didSet {
            definitionTextView.setCorner(radius: 10)
            
            definitionTextView.textingStatus(with: .placeHolder("請在此新增字詞解釋..."))
        }
    }
    
    @IBOutlet weak var categoryTF: UITextField! {
        didSet {
            let toolBar = UIToolbar()
            
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.separatorlineBlue
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
        
        delegate?.clickCancel(self)
        
    }
    
    @IBAction func clickSend(_ sender: UIButton) {

        delegate?.clickSend(self, newWord: newWordTF.text, definition: definitionTextView.text, category: categoryTF.text)
        
    }
    
    @objc func donePicker() {
        
        delegate?.clikckDone(categoryTextField: categoryTF)
        
    }
    
}
