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
    
    private let viewModel: AddNewWordViewModel = .init()
    
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
        
        renderDoneButton()
        
        binding()
        
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func clickSend(_ sender: UIButton) {

        viewModel.createNewWord(word: newWordTF.text, definition: definitionTextView.text, category: categoryTF.text) {
            
            self.dismiss(animated: true)
            
        }
    }
    
    @objc func donePicker() {

        categoryTF.text = viewModel.pickerView(selectRowAs: categoryTF.text)
        
        categoryTF.resignFirstResponder()
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
        
        textView.textingStatus(with: .startTyping(color: .black))
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
        
        let category = viewModel.categoryList[row].instance()
        
        pickerView.resignFirstResponder()
        
        return categoryTF.text = category.name
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let category = viewModel.categoryList[row].instance()
        
        return category.name
    }
    
}

private extension AddNewWordViewController {
    
    func setup() {
        
        newWordTF.delegate = self
        
        categoryTF.delegate = self
        
        definitionTextView.delegate = self

        checkFormValidation()
        
        definitionTextView.setCorner(radius: 10)
        
        definitionTextView.textingStatus(with: .placeHolder("請在此新增字詞解釋..."))
        
        sendButton.setCorner(radius: 10)
        
        navigationItem.setBarAppearance(with: .separatorlineBlue)
        
        view.backgroundColor = .separatorlineBlue
        
        containerView.backgroundColor = .separatorlineBlue
        
        pickerView = UIPickerView()
        
    }
    
    func renderDoneButton() {
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
    
    func binding() {
        
        viewModel.updateStatus = { [weak self] (isValid) in
            
            self?.sendButton.backgroundColor = isValid ? .white : .lightGray
            
            self?.sendButton.isEnabled = isValid
            
        }
        
    }
    
    func checkFormValidation() {
        
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
