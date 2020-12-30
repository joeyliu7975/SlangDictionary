//
//  AddNewWordViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit
import Lottie

class AddNewWordViewController: UIViewController {
    
    @IBOutlet weak var addNewWordView: AddNewWordView!
    
    var viewModel: AddNewWordViewModel = .init()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
        setupAddNewWordView()
        
        viewModelBinding()
        
    }
}

extension AddNewWordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkFormValidation()
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.markedTextRange == nil && (textField.text?.count ?? 0) > 9 {
            textField.text = String(textField.text?.prefix(9) ?? "")
            
            addNewWordView.updateLimitOfWord(number: 0)
        }
        
        if textField.markedTextRange == nil {
        
            let remainder = 9 - (textField.text?.count ?? 0)
            
            addNewWordView.updateLimitOfWord(number: remainder)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let validString = NSCharacterSet.newWordTextField
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil {
            return false
        }
        
        if let _ = string.rangeOfCharacter(from: validString as CharacterSet) {
            
            return false
        }
        
        if (textField.text?.count ?? 0) >= 9 && range.length == 0 && textField.markedTextRange == nil {
            return false
        }
        
        return true
    }
}

extension AddNewWordViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.becomeFirstResponder()
        
        if textView.hasPlaceholder {
            
            textView.clearText()
        }
        
        textView.textingStatus(with: .startTyping)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        checkFormValidation()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let validString = NSCharacterSet.textViewValidString
        
        if (textView.textInputMode?.primaryLanguage == "emoji") || textView.textInputMode?.primaryLanguage == nil {
            return false
        }
        
        if let _ = text.rangeOfCharacter(from: validString as CharacterSet) {
            
            return false
        }
        
        return true
    }
}

extension AddNewWordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let name = viewModel.categoryName(at: row)
        
        pickerView.resignFirstResponder()
        
        addNewWordView?.updateText(target: addNewWordView?.categoryTF, with: name)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let name = viewModel.categoryName(at: row)
        
        return name
    }
}

extension AddNewWordViewController: AddNewWordViewDelegate {
    
    func clickCancel() {
        
        self.dismiss(animated: true)
        
    }
    
    func clickSend(_ view: UIView, newWord: String?, definition: String?, category: String?) {
        
        viewModel.create(word: newWord, definition: definition, category: category) { [weak self] (shouldUpdateChallenge) in
            
            switch shouldUpdateChallenge {
            case true:
                self?.viewModel.updateChallenge {
                   
                    DispatchQueue.main.async {
                        HUDAnimation.showSuccess(at: .newWord) {
                            self?.dismiss(animated: true)
                        }
                    }
                    
                }
            case false:
                
                self?.viewModel.updateChallenge {
                    DispatchQueue.main.async {
                        HUDAnimation.showError(at: .newWord) {
                            self?.dismiss(animated: true)
                        }
                    }
                }
                
            }
        }
    }
    
    func clikckDone(categoryTextField: UITextField) {
        categoryTextField.text = viewModel.pickerView(selectRowAs: categoryTextField.text)
        
        categoryTextField.resignFirstResponder()
    }
}

private extension AddNewWordViewController {
    
    func setup() {
        
        overrideUserInterfaceStyle = .light
        
        navigationItem.setBarAppearance(color: .separatorlineBlue)
        
        addNewWordView.newWordTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func setupAddNewWordView() {
        
        addNewWordView.pickerView = UIPickerView()
        
        addNewWordView.delegate = self
        
        addNewWordView.backgroundColor = .separatorlineBlue
        
        checkFormValidation()
    }
    
    func viewModelBinding() {
        
        viewModel.updateStatus = { [weak self] (isValid) in
            
            self?.addNewWordView.sendButtonValidation(isValid)
            
        }
        
    }
    
    func checkFormValidation() {
        guard
            let defintion = addNewWordView.definitionTextView,
            let newWord = addNewWordView.newWordTF,
            let category = addNewWordView.categoryTF else { return }
        
        viewModel.checkFormValidation(definitionStatus: defintion.textingStauts, definition: defintion.text, newWord: newWord.text, category: category.text)
    }
}
