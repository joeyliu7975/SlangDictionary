//
//  CategoryViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var confirmButtonContainerView: UIView!
    
    @IBOutlet weak var cancelButtonContainerView: UIView!
    
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: CategoryDelegate?
    
    private var selectionBorderView: UIView = .init()
    
    let categoryList = Category.allCases
    
    var selectCategory: Category? {
        willSet {
            if let previousCategory = selectCategory,
               let index = categoryList.firstIndex(of: previousCategory) {
                
                let indexPath = IndexPath(row: index, section: 0)
                
                let selectedCell = categoryCollectionView.cellForItem(at: indexPath)
                
                guard let cell = selectedCell as? CategoryCollectionViewCell else { return }
                
                cell.removeBorderView(&selectionBorderView)
            }
        }
        
        didSet {
            switch selectCategory == nil {
            case true:
                disableButton()
            case false:
                enableButton()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
        setupCollectionView()
        
        disableButton()
    }
    
    @IBAction func confirmSelection(_ sender: UIButton) {
        
        switch sender {
        case confirmButton:
            guard let selectedCategory = self.selectCategory else { return }
            
            delegate?.confirmSelection(selectedCategory)
        default:
            delegate?.cancelSelection()
        }
        
        self.dismiss(animated: true)
    }
}

private extension CategoryViewController {
    func setup() {
        
        containerView.setCorner(radius: 20.0)
        
        confirmButtonContainerView.setCorner(radius: 10.0)
        
        cancelButtonContainerView.setCorner(radius: 10.0)
        
        cancelButton.backgroundColor = .homepageDarkBlue
    }
    
    func setupCollectionView() {
        
        categoryCollectionView.registerCell(CategoryCollectionViewCell.identifierName)
        
        categoryCollectionView.delegate = self
        
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.allowsMultipleSelection = false
    }
    
    func disableButton() {
        
        confirmButtonContainerView.backgroundColor = .lightGray
        
        confirmButton.isEnabled = false
    }
    
    func enableButton() {
        
        confirmButtonContainerView.backgroundColor = .homepageDarkBlue
        
        confirmButton.isEnabled = true
    }
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Select Category
        selectCategory = categoryList[indexPath.row]
        
        if let selectedCell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: indexPath.section)) as?
            CategoryCollectionViewCell {
            selectedCell.addBorderView(&selectionBorderView)
        }
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CategoryCollectionViewCell = collectionView.makeCell(indexPath: indexPath)
                
        let category = categoryList[indexPath.row]
        
        let icon = category.instance()
        
        cell.renderUI(title: icon.name, image: icon.image)
        
        return cell
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = categoryCollectionView.bounds.width
    
        let height: CGFloat = categoryCollectionView.bounds.height
        
        return CGSize(width: width / 3, height: height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

protocol CategoryDelegate: class {
    func confirmSelection(_ selectedCategory: Category)
    
    func cancelSelection()
}
