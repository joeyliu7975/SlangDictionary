//
//  AddNewWordViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class AddNewWordViewController: UIViewController {
    
    @IBOutlet weak var addNewWordView: AddNewWordView!
    
    private let viewModel: AddNewWordViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
        setupAddNewWordView()
                
        binding()
        
    }
}

extension AddNewWordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let addNewWordView = addNewWordView else { return }
        
        checkFormValidation(definitionTextView: addNewWordView.definitionTextView, newWordTF: addNewWordView.newWordTF, categoryTF: addNewWordView.categoryTF)
        
    }
}

extension AddNewWordViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.becomeFirstResponder()
        
        if textView.hasPlaceholder {
            
            textView.clearText()
        }
        
        textView.textingStatus(with: .startTyping(color: .black))
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let addNewWordView = addNewWordView else { return }
        
        checkFormValidation(definitionTextView: addNewWordView.definitionTextView, newWordTF: addNewWordView.newWordTF, categoryTF: addNewWordView.categoryTF)
        
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
        
        let category = viewModel.categoryList[row].instance()
        
        pickerView.resignFirstResponder()
        
        addNewWordView?.categoryTF.text = category.name
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let category = viewModel.categoryList[row].instance()

        return category.name
    }
}

extension AddNewWordViewController: AddNewWordViewDelegate {
    
    func clickCancel(_ view: UIView) {
        
        self.dismiss(animated: true)
        
    }
    
    func clickSend(_ view: UIView, newWord: String?, definition: String?, category: String?) {
        viewModel.createNewWord(word: newWord, definition: definition, category: category) {
       
                   self.dismiss(animated: true)
       
            }
    }
    
    func clikckDone(categoryTextField: UITextField) {
        categoryTextField.text = viewModel.pickerView(selectRowAs: categoryTextField.text)
        
        categoryTextField.resignFirstResponder()
    }
}

private extension AddNewWordViewController {
    
    func setup() {
        
        navigationItem.setBarAppearance(with: .separatorlineBlue)
        
    }
    
    func setupAddNewWordView() {
        
        guard let addNewWordView = addNewWordView else { return }
        
        addNewWordView.pickerView = UIPickerView()
        
        addNewWordView.delegate = self
        
        addNewWordView.newWordTF.delegate = self
        
        addNewWordView.categoryTF.delegate = self
        
        addNewWordView.definitionTextView.delegate = self
        
        addNewWordView.pickerView?.delegate = self
        
        checkFormValidation(definitionTextView: addNewWordView.definitionTextView, newWordTF: addNewWordView.newWordTF, categoryTF: addNewWordView.categoryTF)
        
        addNewWordView.backgroundColor = .separatorlineBlue
    }
    
    func binding() {
        
        viewModel.updateStatus = { [weak self] (isValid) in

            guard let addNewWordView = self?.addNewWordView else { return }
            
            
            addNewWordView.sendButton.backgroundColor = isValid ? .white : .lightGray

            addNewWordView.sendButton.isEnabled = isValid

        }
        
    }
    
    func checkFormValidation(definitionTextView: UITextView, newWordTF: UITextField, categoryTF: UITextField) {

        if definitionTextView.textColor == .placeholderText { return }

        viewModel.containEmptyString(
            newWord: newWordTF.text,
            definition: definitionTextView.text,
            category: categoryTF.text
        ) { [weak self] (isEnable) in
            self?.viewModel.isEnable = isEnable
        }
    }
}
