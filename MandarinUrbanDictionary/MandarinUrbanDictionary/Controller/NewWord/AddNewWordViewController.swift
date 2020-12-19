//
//  AddNewWordViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class AddNewWordViewController: UIViewController {
    
    @IBOutlet weak var addNewWordView: AddNewWordView!
    
    private var viewModel: AddNewWordViewModel = .init()
    
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
        
        addNewWordView.pickerView = UIPickerView()
        
        addNewWordView.delegate = self
        
        addNewWordView.newWordTF.delegate = self
        
        addNewWordView.categoryTF.delegate = self
        
        addNewWordView.definitionTextView.delegate = self
        
        addNewWordView.pickerView?.delegate = self
        
        addNewWordView.backgroundColor = .separatorlineBlue
        
        checkFormValidation()
    }
    
    func viewModelBinding() {
        
        viewModel.updateStatus = { [weak self] (isValid) in

            guard let addNewWordView = self?.addNewWordView else { return }
            
            addNewWordView.sendButton.backgroundColor = isValid ? .white : .lightGray

            addNewWordView.sendButton.isEnabled = isValid

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
